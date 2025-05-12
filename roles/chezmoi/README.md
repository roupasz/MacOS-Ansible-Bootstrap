- [chezmoi](#chezmoi)
  - [Prerequisites:](#prerequisites)
  - [Files](#files)
  - [Variables](#variables)
  - [Paramaters](#paramaters)

chezmoi
=========

This `chezmoi` Ansible role, is used to install [chezmoi](https://www.chezmoi.io/) dotfile manager which handles templated (an not only) config files. It needs `--ask-vault-pass` because the `files/key` used by `chezmoi` should be encrypted, personally I use `ansible-vault` but for visibility reasons in this case, the file un encrypted for better understanding of how it should look like after generated.

Due to the fact that I'm working in different workstations, I wanted a way to install different dotfiles for my work and personal workstation.\
For example, I wanted to have my `.terraformrc` in my work machine but not for my personal one. Or I wanted my `.netrc.j2` to have different entries for different machines.

This is where `chezmoi` comes in, which is able to create such templated files and encrypt sensitive data to safely store them to repos.

Prerequisites:
------------

A different repo that is already configured via [chezmoi](https://www.chezmoi.io/). 
I strongly recommend to encrypt sensitive, I decided to use [age](https://www.chezmoi.io/user-guide/encryption/age/).

Files
--------------

- `key.txt` : The generated encryption key used by age to decrypt files. Should be encrypted in case you want to store it in a repo.
- `chezmoi.toml` : Chezmoi configuration file. Find more info [here](https://www.chezmoi.io/reference/configuration-file/#examples)


Variables
--------------

- `chezmoi_install_method: "download"` : Specifies how chezmoi is installed.
- `chezmoi_init_url`: The repo that holds your chezmoi templated dotfiles. Used during chezmoi init with a given URL. You can also specify a Github username.

Paramaters
--------------

n/a
