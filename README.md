# Tools to come

- git submodule order: yield a build order for submodules of a current git repo.

# Known issues

- git issue should work in multiple repositories simultaneosly. It should store state somewhere reasonable

# Development

## git-ignore

### Scoping

What else is scoped?
* git config
  * --system: AFAICT, there is no system level gitignore
  * --global: this is the user level, from config core.excludesfile
  * --local: $repo/.git/config
  * --file $file
  
* go with scopes

global: from core.excludesfile
local: root(repo)/.git/info/exclude
root (the default): root(repo)/.gitignore
dir: $PWD/.gitignore



- git ignore should be able to be scoped at a level:
  - user: ~/.gitignore
  - repo: ${git root}/.gitignore
  - local: ${git root}/.git/info/exclude
  
  
  
  

