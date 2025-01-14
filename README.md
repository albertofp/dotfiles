# albertofp's dotfiles

## Usage

1. [on MacOS]: Enable remote login
2. Get IP address of new machine: `
3. Copy over `.ansible_vault_pass.txt` to new machine
4. Clone / Download repo code and run `./bin/dotfiles`

```bash
# On new machine
ifconfig en0 | grep 'inet ' | awk '{print $2}' | tr -d '\n'`

# On old machine
scp $HOME/..ansible_vault_pass.txt <remote-user>@<remote-ip>:</path/to/home>.ansible_vault_pass.txt
```

```bash
git clone https://github.com/albertofp/dotfiles
cd dotfiles
./bin/dotfiles
```

## TODO

- [x] Add README
- [x] set up ansible-vault for storing SSH keys
- [x] add stow to playbooks
- [x] automate zsh config in playbooks
- [x] set up .gitconfig
- [x] port dotfiles.sh to Go using the [go-ansible](https://github.com/apenella/go-ansible) package
- [x] linting action
