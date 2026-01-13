# GitHub Copilot Instructions

## Project Overview
- Flake-based NixOS and Home Manager configs for multiple personal machines.
- Primary targets live under [hostnames](hostnames) with reusable modules in [hostnames/modules](hostnames/modules) and per-user Home Manager modules in [home/modules](home/modules).
- Builds rely on unstable nixpkgs plus the upstream nixos-hardware and home-manager inputs declared in [flake.nix](flake.nix).

## Repository Layout
- Each host directory (for example [hostnames/joonas-linux](hostnames/joonas-linux)) imports hardware, common, and optional feature modules.
- Shared NixOS feature modules (cosmic, locales, networking, etc.) sit in [hostnames/modules](hostnames/modules); keep them host-agnostic.
- Home Manager configs reside under [home/joonas](home/joonas) and compose focused modules for tools like git, bash, ssh, and tmux.
- Global defaults such as sudo, fonts, and caching are centralized in [hostnames/modules/common.nix](hostnames/modules/common.nix#L1-L43).

## Core Workflows
- Rebuild a NixOS host from the repo root with `nix rebuild switch --flake .#<hostname>`.
- Apply Home Manager changes with `home-manager switch --flake .#joonas@<hostname>`.
- Update dependencies via `nix flake update`; review the resulting lock-file diff before committing.

## NixOS Module Patterns
- Modules follow the `{ config, pkgs, ... }: { ... }` signature and expose plain attribute sets; prefer enabling services via declarative options.
- Host configs import modules explicitly—commented entries in files like [hostnames/joonas-linux/configuration.nix](hostnames/joonas-linux/configuration.nix#L9-L24) document optional stacks (GNOME, KDE, Hyprland, etc.).
- Keep secrets out of the repo; modules such as [hostnames/modules/networking.nix](hostnames/modules/networking.nix) should stay credential-free and rely on systemd services or environment variables when needed.
- Use dedicated modules (for example [hostnames/modules/cosmic.nix](hostnames/modules/cosmic.nix)) to bundle related display-manager and desktop tweaks, including agent and keyring settings.

## Home Manager Conventions
- Home configs import only the modules the user needs (see [home/joonas/joonas-linux.nix](home/joonas/joonas-linux.nix#L1-L25)).
- Modules expose precise program blocks—e.g. [home/modules/git.nix](home/modules/git.nix#L1-L11) sets name, email, and git defaults in one place.
- Set `home.stateVersion` per host and touch it only during major Home Manager upgrades.
- Prefer package management through Home Manager when it affects userland tooling, leaving system packages to the host configs.

## Package and Service Guidelines
- Unfree packages are allowed explicitly either in host configs or via `nixpkgs.config.allowUnfree = true;` as shown in [hostnames/joonas-linux/configuration.nix](hostnames/joonas-linux/configuration.nix#L72-L88).
- Shared system package lists live in modules like [hostnames/modules/common.nix](hostnames/modules/common.nix#L8-L34); add machine-specific software in the host file’s `environment.systemPackages`.
- Fonts and locales are standardized through [hostnames/modules/common.nix](hostnames/modules/common.nix#L27-L43) and [hostnames/modules/locales.nix](hostnames/modules/locales.nix).
- SSH agent preferences are set once in common modules; avoid reconfiguring them in individual hosts unless required.

## Adding or Modifying Hosts
- New machines should reuse `nixosSystemFor` from [flake.nix](flake.nix#L18-L37) and follow the pattern in existing entries under `nixosConfigurations` and `homeConfigurations`.
- Generate hardware profiles with `nixos-generate-config` and drop them into the host directory as `hardware-configuration.nix`.
- Ensure `system.stateVersion` reflects the target NixOS release; do not bump without reviewing release notes.
- When enabling experimental desktops (GNOME, COSMIC, etc.), wire them in via the appropriate module to keep host files readable.