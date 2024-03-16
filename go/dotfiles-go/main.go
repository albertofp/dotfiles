package main

import (
	"context"
	"fmt"
	"os"
	"os/exec"
	"runtime"

	"github.com/apenella/go-ansible/v2/pkg/execute"
	"github.com/apenella/go-ansible/v2/pkg/execute/configuration"
	"github.com/apenella/go-ansible/v2/pkg/playbook"
)

func main() {
	var (
		home          = os.Getenv("HOME")
		osType        = runtime.GOOS
		dotfilesDir   = home + "/dotfiles"
		playbookFile  = dotfilesDir + "/ansible/bootstrap.yaml"
		vaultPassFile = home + "/.ansible_vault_pass.txt"
	)

	opt := &playbook.AnsiblePlaybookOptions{
		Connection:    "local",
		Inventory:     "localhost,",
		AskBecomePass: true,
	}

	switch osType {
	case "linux":
		if _, err := exec.LookPath("ansible"); err != nil {
			err := exec.Command("sudo", "pacman", "-S", "--noconfirm", "ansible").Run()
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}
		}
	case "darwin":
		if _, err := exec.LookPath("brew"); err != nil {
			fmt.Println("Installing Homebrew...")
			err := exec.Command("/bin/bash", "-c", "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)").
				Run()
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}
		}

		if _, err := exec.LookPath("ansible"); err != nil {
			fmt.Println("Installing Ansible...")
			err := exec.Command("brew", "install", "ansible").Run()
			if err != nil {
				fmt.Println(err.Error())
				os.Exit(1)
			}
		}
	default:
		fmt.Println("Unsupported OS; Exiting...")
		os.Exit(0)
	}

	if _, err := os.Stat(home + "/.ansible_vault_pass.txt"); os.IsNotExist(err) {
		fmt.Println("No .ansible_vault_pass.txt found in $HOME:")
		opt.AskVaultPassword = true
	} else {
		opt.VaultPasswordFile = vaultPassFile
	}

	playbookCmd := &playbook.AnsiblePlaybookCmd{
		Playbooks:       []string{playbookFile},
		PlaybookOptions: opt,
	}

	exec := configuration.NewAnsibleWithConfigurationSettingsExecute(
		execute.NewDefaultExecute(
			execute.WithCmd(playbookCmd),
		),
		configuration.WithAnsibleForks(10),
		configuration.WithAnsiblePythonInterpreter("auto_silent"),
		configuration.WithAnsibleForceColor())

	err := exec.Execute(context.Background())
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
}
