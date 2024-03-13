# albertofp's dotfiles

## TODO

- [x] Add README
- [x] set up ansible-vault for storing SSH keys
- [ ] add stow to playbooks
- [ ] set up .gitconfig
- [ ] port dotfiles.sh to Go using lipgloss + [go-ansible](https://github.com/apenella/go-ansible) package

## Considerations

- Keep using Stow? Or just move completely to ansible
  - Use ansible to call stow
- Add support for both private and work githubs?
- What needs to be encrypted?
- Linting/checks in github actions?
- Does .kube/ belong in dotfiles
- Support for auto generation of tags for notes w/ OpenAI API?
