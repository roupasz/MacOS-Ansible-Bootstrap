- [Role Name](#role-name)
  - [Prerequisites:](#prerequisites)
  - [Role Variables](#role-variables)
  - [Dependencies](#dependencies)


Role Name
=========

This `config-files` Ansible role, is cloning the repo that holds my config and dotfiles by leveraging the `files/netrc.j2` file.

In more detail, the role extracts the transcrypt password, used to encrypt the relevant dotfiles repo, from bitwarden, checks if the repo is already cloned under a specific path and if not, proceeds by cloning and decrypting it.

Finally, the role executes my Dotbot based config and dotfiles initialization. For more details on Dotbot, have a look [here](https://github.com/anishathalye/dotbot)

Prerequisites:
------------

A valid Bitwarden login session must be established before this role runs. This is typically handled automatically by `bootstrap.sh` during a full execution, or manually via sourcing `examples/.env` when troubleshooting.

Role Variables
--------------

`output_file_path: "/path/to/your/.netrc"` : This is the path where .netrc.j2 will be deployed to. Usually needs to be under home directory.\
`note_id_or_name: "<secure_note_name>"` : The name of the Bitwarden Secure Note that holds the token used for repo cloning.\
`gitlab_repo_url: "https://github.com/<user>/repo.git"` : The repo that holds the config/dofiles based on Dotbot tool.\
`repo_dest: "{{ ansible_env.HOME }}/path/to/repo"` : This is the path where the repo will be cloned to and initialized from.

Dependencies
------------

n/a