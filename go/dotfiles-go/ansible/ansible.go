package ansible

import (
	"context"
	"fmt"
	"os"

	"github.com/apenella/go-ansible/v2/pkg/execute"
	"github.com/apenella/go-ansible/v2/pkg/execute/configuration"
	"github.com/apenella/go-ansible/v2/pkg/playbook"
)

type AnsibleCfg struct {
	Vault    string
	Playbook string
}

func RunPlaybook(c AnsibleCfg) error {
	opt := &playbook.AnsiblePlaybookOptions{
		Connection:    "local",
		Inventory:     "localhost,",
		AskBecomePass: true,
	}

	if _, err := os.Stat(c.Vault); os.IsNotExist(err) {
		fmt.Println("No ansible vault pass file found in " + c.Vault)
		opt.AskVaultPassword = true
	} else {
		opt.VaultPasswordFile = c.Vault
	}

	playbookCmd := &playbook.AnsiblePlaybookCmd{
		Playbooks:       []string{c.Playbook},
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
	return err
}
