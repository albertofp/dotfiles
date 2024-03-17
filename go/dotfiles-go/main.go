package main

import (
	"os"

	"github.com/albertofp/dotfiles-go/ansible"
	"github.com/albertofp/dotfiles-go/deps"
)

func main() {

	if err := deps.GetDeps(); err != nil {
		panic(err.Error())
	}

	cfg := ansible.AnsibleCfg{
		Vault:    os.Getenv("HOME") + "/.ansible_vault_pass.txt",
		Playbook: os.Getenv("HOME") + "/dotfiles/ansible/bootstrap.yaml",
	}

	err := ansible.RunPlaybook(cfg)
	if err != nil {
		panic(err.Error())
	}
}
