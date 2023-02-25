# Dotfiles

<!--toc:start-->
- [Dotfiles](#dotfiles)
  - [Installation](#installation)
    - [macOS installation](#macos-installation)
  - [Testing](#testing)
<!--toc:end-->

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
To update submodules excluding the private submodule:
```shell
while read -r submodule; do
  git submodule init "$submodule"
done < <(git submodule status | cut -f2 -d' ' | sed 's%/.*%%' | sort | uniq | grep -v 'private')
git submodule update
```
Then run the correct install script for your system, e.g.
```shell
./install_linux.sh
```

### macOS installation
```shell
./private/mac/install_deps
./mac/osx
./install_mac.sh
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
