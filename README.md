# Dotfiles

See also:
- https://github.com/geerlingguy/dotfiles
- https://github.com/mathiasbynens/dotfiles
- https://github.com/pawelgrzybek/dotfiles
- https://gist.github.com/brandonb927/3195465/
- https://github.com/jessarcher/dotfiles
- https://github.com/theprimeagen/.dotfiles

## Installation

```shell
git clone --recursive https://github.com/aaronkollasch/dotfiles ~/.dotfiles
cd ~/.dotfiles
```
To update submodules (should already be installed by `git clone --recursive`):
```shell
git submodule init && git submodule update
```
Then run the correct install script for your system, e.g.
```shell
./install_linux.sh
```

## Testing

```shell
./run_tests.sh
```

Requirements:
- bash 5+
- zsh
- current awk
- fd-find
- shellcheck
- vim
- python3
- black
