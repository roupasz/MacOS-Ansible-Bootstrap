config-files
=========

Role that will to install all other dotfiles that aren't templated via chezmoi.

The role will retrieve the transcrypt encryption password from a bitwarden note, will clone the relevant repo if not present, will decrypt the repo via the retrieved password and run dobot to initiate dotiles and their configurations.

Requirements
------------
n/a

Variables
--------------

- `note_id_or_name` : The note or id of the bitwarden note that holds the trancrypt password used to decrypt the repo.
- `gitlab_repo_url` : The repo that holds the Dotbot dotfiles.
- `repo_dest` : The path that repo is going to be cloned and decrypted

Paramaters
--------------

n/a