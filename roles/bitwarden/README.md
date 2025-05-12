- [Role Name](#role-name)
  - [Prerequisites:](#prerequisites)
  - [Role Variables](#role-variables)
  - [Dependencies](#dependencies)
  - [Execution](#execution)


Role Name
=========

This `default` Ansible role, is required by the setup script to enable cloning of specific repositories as part of the bootstrap process.

The role retrieves the necessary token from a Bitwarden Secure Note and stores it as a variable. This token is then injected into the templated `files/netrc.j2` file, which is subsequently moved to the appropriate location.

Prerequisites:
------------

A valid Bitwarden login session must be established before this role runs. This is typically handled automatically by `bootstrap.sh` during a full execution, or manually via sourcing `examples/.env` when troubleshooting.

Role Variables
--------------

`note_id_or_name: "<secure_note_name>"` : The name of the Bitwarden Secure Note that holds the token used for repo cloning.
`output_file_path: "/path/to/your/.netrc"` : This is the path where .netrc.j2 will be deployed to. Usually needs to be under home directory.

Dependencies
------------

User should have a Github/Gitlab Token with appropriate permissions.

Execution
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

Execute via 
```shell
./bootstrap.sh --tags bw
```
or
```shell
ansible-playbook main_playbook.yml --tags "bw"
```