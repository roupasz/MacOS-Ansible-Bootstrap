- [Role Name](#role-name)
  - [Prerequisites:](#prerequisites)
  - [Role Variables](#role-variables)
  - [Dependencies](#dependencies)


Role Name
=========

This `gpg_import` Ansible role, is cloning the repo that holds my encrypted gpg keys and imports them in the gpg machine keychain.

In more detail, the role extracts the transcrypt password, used to encrypt the relevant encrypted keys repo, from bitwarden, checks if the repo is already cloned under a specific path and if not, proceeds by cloning and decrypting it.

Finally, based on the hostname, the role checks if the gpg key(s) are present and if not proceeds by importing them.

The role, gives you the chance to investigate which keys are going to be imported and asks for approval before moving on.

Prerequisites:
------------

A valid Bitwarden login session must be established before this role runs. This is typically handled automatically by `bootstrap.sh` during a full execution, or manually via sourcing `examples/.env` when troubleshooting.

Role Variables
--------------

`output_file_path: "/path/to/your/.netrc"` : This is the path where .netrc.j2 will be deployed to. Usually needs to be under home directory.\
`note_id_or_name: "<secure_note_name>"` : The name of the Bitwarden Secure Note that holds the token used for repo cloning.\
`gitlab_repo_url: "https://github.com/<user>/repo.git"` : The repo that holds the config/dofiles based on Dotbot tool.\
`repo_dest: "{{ ansible_env.HOME }}/path/to/repo"` : This is the path where the repo will be cloned to and initialized from.

`gpg_keys: <key1, key2>` : The list of gpg key fingerprints that will imported based on the hostname. The hostname is added, in order to be able to add specific gpg keys to specific machines and distinguish from work and personal.\
`note_id_or_name: "<secure_note_name>"` : The name of the Bitwarden Secure Note that holds the token used for repo cloning.\
`gitlab_repo_url: "https://github.com/<user>/repo.git"` : The repo that holds the encrypted gpg keys.\
`repo_dest: "{{ ansible_env.HOME }}/path/to/repo"` : This is the path where the repo will be cloned to and initialized from.

Dependencies
------------

The keys in the encrypted repo, should be saved based on the fingerprint, as this ID is used in order to check and import them if missing, e.g., `B93D4C791C2183BC76.asc`.