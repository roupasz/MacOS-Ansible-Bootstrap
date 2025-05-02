homebrew_packages
=========

Role that will to install mac os related homebrew and cask packages.

Requirements
------------

n/a

Variables
--------------

- `brew_cask_packages` : A list of Homebrew cask packages to install.
- `brew_cask_bootsrap_packages`: An optional list of Homebrew cask packages to install in fresh systems.
- `brew_packages`: A list of Homebrew packages to install.

Parameters
------------

- `install_homebrew_if_missing`: Whether to install Homebrew if it is not found.
- `upgrade_homebrew_packages`: Whether to upgrade all installed Homebrew packages. 
- `install_cask_bootsrap_packages` : Whether to install optional Homebrew cask packages. Default is `false` and updated automatically to `true` when run via `bootstrap.sh`. Can also be enabled via ansible with `--extra-vars install_cask_bootsrap_packages=true`.
