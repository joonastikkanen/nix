# Nix Configurations

Build new NixOS build:

```
$ nix rebuild switch --flake .#<HOSTNAME>
```

Update flake:

```
$ nix flake update
```

## Home-Manager

Install
```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

Install home configruation:
```
home-manager switch --flake .#USER@<HOSTNAME>
```
