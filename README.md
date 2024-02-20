# My dotfiles

This directory contains the dotfiles for my system

## Requirements

The following utilities must be installed on your system. For a Debian-based distribution, the commands are as follows:

### Git
```
$ sudo apt install git
```

### Stow
```
$ sudo apt install stow
```

## Installation

First, clone the dotfiles repo in your $HOME directory using git
```
$ git clone https://github.com/PedroVidalVillalba/dotfiles.git
```
or
```
$ gh repo clone PedroVidalVillalba/dotfiles
```

Then, use GNU stow to create symlinks
```
stow -d ~/dotfiles/ -t ~
```
