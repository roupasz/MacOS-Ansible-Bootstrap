chezmoi
=========

Role that will install chezmoi dotfile handler used for templated config files. It needs `--ask-vault-pass` because the key used by chezmoi should be encrypted with `ansible-vault`

Requirements
------------
n/a

Variables
--------------

- `chezmoi_install_method: "download"` : Specify how to install chezmoi
- `chezmoi_init_url`: The repo that holds the chezmoi templated dotfiles.Used in chezmoi init with a given URL. You can also specify a Github username.

Paramaters
--------------

n/a
