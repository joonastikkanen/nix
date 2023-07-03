# Nix Configurations

Build new NixOS build:

```
$ nixos-rebuild test
$ nixos-rebuild build -p conf-`date +'%Y%m%d%H%M'`
$ nixos-rebuild switch -p conf-`date +'%Y%m%d%H%M'`
```