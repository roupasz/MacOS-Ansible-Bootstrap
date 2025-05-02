gpg_import
=========

Role that will import gpg keys if not present already.

The role will retrieve the transcrypt encryption password from a bitwarden note, will clone the relevant repo if not present, will decrypt the repo via the retrieved password and check which gpg keys are missing based on the hostname.

Requirements
------------
n/a

Variables
--------------

- `gpg_keys` : List of gpg fingreprints imported based on machine hostname.
- `note_id_or_name` : The note or id of the bitwarden note that holds the trancrypt password used to decrypt the repo.
- `gitlab_repo_url` :  The repo that holds the gpg keys.
- `repo_dest` :  The path that repo is going to be cloned and decrypted

Paramaters
--------------

n/a