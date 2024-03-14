# Nix Configurations

Build new NixOS build:

```
$ nix rebuild switch --flake .#<HOSTNAME>
```

Update flake:

```
$ nix flake update
```