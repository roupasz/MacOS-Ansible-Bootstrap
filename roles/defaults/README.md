- [Role Name](#role-name)
  - [Prerequisites:](#prerequisites)
  - [Role Variables](#role-variables)
    - [Font paths](#font-paths)
    - [Settings paths](#settings-paths)
  - [Scripts](#scripts)
  - [Dependencies](#dependencies)


Role Name
=========

This simple `defaults` Ansible Role, is copying some fonts that I like and use in iTerm2. There were some fonts installed via brew at some point of future, but support was dropped. I decided to add this

The role, is also applying some generic OS settings that I'm using from machine to machine via the `scripts/defaults.sh`. Not all of them work as expected and it is in my TODO's to fix those when I find some time, but for now the important ones are working as expected.

Finally, it updates keyboard shortcuts for Input Language and Spotlight (it swaps cmd+space to Language Input and ctrl+space to Spotlight search).

Prerequisites:
------------

n/a

Role Variables
--------------

### Font paths
`font_src_path: <src_path>` : Fonts source path 
`font_dest_path: <dest_path>` : Fonts destination path

### Settings paths
`plist_src_path: <src_path>` : Plist settings source path
`plist_dest_srv: <dest_path>` : Plist settings destination path

Scripts
------------

The `scripts/defaults.sh` script is a collection of useful snippets that I’ve compiled over the years, found in different github repos used by many different engineers. My major TODO here is to also automate iTerm2 configuration but for various reasons, I haven't given time to do so but I have some useful comments.

Dependencies
------------

n/a