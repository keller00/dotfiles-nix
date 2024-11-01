# Personal nix dotfiles

## Setup instructions

### Install nix

```shell
curl -L https://nixos.org/nix/install | sh
```

### Adding home-manager

```shell
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

### Sym-link home-manager config

```shell
❯ cd ~/.config/home-manager

~/.config/home-manager
❯ ln -s ~/Software/dotfiles-nix
```

