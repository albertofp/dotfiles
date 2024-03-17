package deps

import (
	"fmt"
	"os/exec"
	"runtime"
)

func GetDeps() error {
	switch runtime.GOOS {
	default:
		return fmt.Errorf("OS not supported")
	case "linux":
		if _, err := exec.LookPath("ansible"); err != nil {
			err := exec.Command("sudo", "pacman", "-S", "--noconfirm", "ansible").Run()
			if err != nil {
				return err
			}
		}
	case "darwin":
		if _, err := exec.LookPath("brew"); err != nil {
			fmt.Println("Installing Homebrew...")
			err := exec.Command("/bin/bash", "-c", "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/instll.sh)").
				Run()
			if err != nil {
				return err
			}
		}

		if _, err := exec.LookPath("ansible"); err != nil {
			fmt.Println("Installing Ansible...")
			err := exec.Command("brew", "install", "ansible").Run()
			if err != nil {
				return err
			}
		}
	}
	return nil
}
