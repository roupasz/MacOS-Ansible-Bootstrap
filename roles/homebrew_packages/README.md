- [Role Name](#role-name)
  - [Requirements](#requirements)
  - [Variables](#variables)
    - [Default](#default)
    - [Role execution](#role-execution)
    - [Custom](#custom)
  - [Parameters](#parameters)

Role Name
=========

The `homebrew_packages` Ansible Role, is installing a list of brew packages that that should be present in every one of my machines.

Requirements
------------

n/a

Variables
--------------

### Default

`install_homebrew_if_missing: true` : Change to **false** if you don't want to install homebrew. Handled also via `bootstrap.sh`
`upgrade_homebrew_packages: false` : Change to **true** if you want to upgrade packages
`install_cask_bootsrap_packages: false` : Change to true for first boot.Handled also via `bootstrap.sh`

The idea behind `install_cask_bootsrap_packages`, is that if the role is executed in a standalone mode, I only want to persist and install new non cask packages and save time from reinstalling cask ones whcih are usually big ones and take time.

### Role execution
In case this is run as a standalone task, use extra vars to enable/disable functionality.
```shell
ansible-playbook main_playbook.yml --extra-vars install_cask_bootsrap_packages=true
```
install the cask packages only once and save time in case I add a new brew package and re apply. This is also handled via `bootstrap.sh`

### Custom
- `brew_cask_packages` : A list of Homebrew cask packages to be installed.
- `brew_cask_bootsrap_packages`: An optional list of Homebrew cask packages to install in new installations.
- `brew_packages`: A list of Homebrew packages (non graphical applications) to be installed.

Parameters
------------

- `install_homebrew_if_missing`: Whether to install Homebrew if it is not found.
- `upgrade_homebrew_packages`: Whether to upgrade all installed Homebrew packages. 
- `install_cask_bootsrap_packages` : Whether to install optional Homebrew cask packages. Default is `false` and updated automatically to `true` when run via `bootstrap.sh`. Can also be enabled via ansible with `--extra-vars install_cask_bootsrap_packages=true`.
