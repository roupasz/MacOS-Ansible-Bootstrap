> [!IMPORTANT]
> This README is a work in progress.<br>
> I'm sure that many aspects of this repository can be done in a better, more intelligent way. If you have suggestions or enhancements, please feel free to open a PR!<br>
> Tested with: Ansible v2.18.4 & macOS Sequoia 15

- [📝 Overview](#-overview)
- [🚀 New System Bootstrap](#-new-system-bootstrap)
- [🖥️ Bootstrap Script Usage](#️-bootstrap-script-usage)
  - [Order of role execution](#order-of-role-execution)
  - [Ansible Playbook Usage](#ansible-playbook-usage)
  - [New role creation](#new-role-creation)
- [🛡️ Security](#️-security)
- [⚙️ Customization](#️-customization)
- [🐞 Issues / 📝 TODOs](#-issues---todos)
- [🤝 Contributing](#-contributing)
- [🔗 Connect](#-connect)
- [🧑‍💻 About Me](#-about-me)

## 📝 Overview

A collection of ansible roles which install macOS related packages,dependencies, plugins, fonts and system settings.

## 🚀 New System Bootstrap

`bootstrap.sh` prepares the system by installing essential tools (such as Homebrew, Ansible, Bitwarden CLI, etc.) required by the Ansible roles.
Ansible roles then handle package installation, global settings configuration,font installation and dotfile initialization, using both Chezmoi (for templated dotfiles) and Dotbot (for standard dotfiles).

is used to install packages (ex. homebrew, ansible, bitwarden-cli etc) required by the ansible roles which in turn will install packages, configure global settings, initialize both templated dotfiles via Chezmoi and normal ones via Dotbot. 

## 🖥️ Bootstrap Script Usage

```shell
./bootstrap.sh --help                     # Show help message
./bootstrap.sh --install-packages         # Install prerequisite packages
./bootstrap.sh --tags "brew,krew"         # Run with specific tags
./bootstrap.sh --tags "cz" --ask-vault-pass # Use vault password for roles that are using encrypted files.
```
### Order of role execution

In case of full installation, roles are executed in the following order: 

- defaults
- homebrew_packages
- bitwarden
- chezmoi
- config_files
- gpg_import
- krew_plugins

Find a README file inside each role.

### Ansible Playbook Usage

Ansible playbook can be executed in a standalone mode, some example are found below:

```yaml
ansible-playbook main_playbook.yml --ask-vault-pass # to execute all tasks
ansible-playbook main_playbook.yml --ask-vault-pass --tags "cz" # to execute only specific roles which uses encrypted files
ansible-playbook main_playbook.yml --tags "brew", "krew" # to execute package and krew installation
```

### New role creation

If you want to create a new role:

```yaml
ansible-galaxy init <role>
```

Include the role in your playbook:

```yaml
- hosts: localhost
  roles:
    - {role: 'homebrew_packages', tags: 'brew'}
```

## 🛡️ Security 

In case you want to fork, it is strongly recommended that you encrypt files like key.txt and any other file that holds sensitive info. I haven't done it here in order to show you what a file would like like in case you want to follow the same setup.

Check [ansible-vault](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html) for more details.

## ⚙️ Customization

In case you do have a separate repo for your dotfiles, gpg keys etc , then update `chezmoi_init_url`, `gitlab_repo_url` variable in the roles that use it (chezmoi, config_files, gpg_import). Otherwise, comment out the relevant roles in main `main_playbook.yml`.

This procedure is heavily depended to Bitwarden in order to retrieve tokens used during the playbook runtime. If you intend to use this only for package installation, then disable all roles except `homebrew_packages`.

For more customization details, check README files found in each role (wip).

## 🐞 Issues / 📝 TODOs

> [!NOTE] 
> Add an execution diagram flow

* bootstrap script may need some more sanity checks.
* merge similar tasks, like cloning and decrypting repos used during the fresh installation, in one role.
* `gpg_import` role is importing keys even if the keys are present.

## 🤝 Contributing

Contributions and suggestions are welcome! If you spot something that could be improved (and I'm sure you'll find a lot :) ), please open an issue or submit a pull request.

## 🔗 Connect

<p align="left">
<a href="https://linkedin.com/in/roupasz" target="blank"><img align="center" src="./src/images/icons/social/linked-in.svg" alt="roupasz" height="30" width="40" /></a>
<a href="https://instagram.com/paparoup_" target="blank"><img align="center" src="./src/images/icons/social/instagram.svg" alt="roupasz" height="30" width="40" /></a>

## 🧑‍💻 About Me

<a href="https://zoisroupas.dev/" target="_blank">
<img src="https://img.shields.io/website?url=https%3A%2F%2Fzoisroupas.dev%2F&logo=github&style=flat-square" />
</a><br>
I'm a DevOps Engineer specializing in hybrid infrastructure architecture and implementation. I design, deploy, and optimize systems across both on-premise environments and cloud platforms, focusing on automation, CI/CD pipelines, and infrastructure as code to create scalable, resilient solutions.<br>
✍️ [Check out my Blog](https://myhomelab.gr/)