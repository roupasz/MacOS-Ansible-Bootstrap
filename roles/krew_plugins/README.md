Role Name
=========

The `krew_plgins` Ansible Role, is installing a list of krew plugins that that should be present in every one of my machines.

In more detail, it installs `kubectl` and then `krew` before installing the relavant plugins.

Requirements
------------
`Kubectl` should be present.

Variables
--------------

- `krew_plugins` : A list of Krew plugins to be installed.

Paramaters
--------------

n/a