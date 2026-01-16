# Nix Configurations

Flake-based NixOS and Home Manager configurations for multiple personal machines.

## Repository Structure

- **`flake.nix`**: Declares inputs (nixpkgs, home-manager, nixos-hardware) and outputs for NixOS and Home Manager configurations
- **`hostnames/`**: Per-host NixOS configurations
  - `hostnames/modules/`: Reusable NixOS modules (networking, locales, desktop environments, etc.)
  - `hostnames/<hostname>/`: Host-specific configuration and hardware profiles
- **`home/`**: Home Manager configurations
  - `home/modules/`: Reusable user-space modules (git, bash, ssh, tmux, etc.)
  - `home/joonas/`: Per-host Home Manager configs for the joonas user

## Quick Start

### Building a NixOS Configuration

```bash
nix rebuild switch --flake .#<HOSTNAME>
```

Replace `<HOSTNAME>` with your target machine (e.g., `joonas-linux`).

### Applying Home Manager Changes

```bash
home-manager switch --flake .#joonas@<HOSTNAME>
```

### Updating Dependencies

```bash
nix flake update
```

Review the `flake.lock` diff before committing.

## Adding a New Host

1. Generate hardware configuration:

   ```bash
   nixos-generate-config --root /mnt --show-hardware-config > hostnames/<new-host>/hardware-configuration.nix
   ```

2. Create `hostnames/<new-host>/configuration.nix` importing desired modules from `hostnames/modules/`

3. Add entries to `flake.nix`:
   - `nixosConfigurations.<new-host>` using `nixosSystemFor`
   - `homeConfigurations."joonas@<new-host>"` using `homeManagerConfigurationFor`

4. Set appropriate `system.stateVersion` and `home.stateVersion`

## Module Organization

### NixOS Modules (`hostnames/modules/`)

- **`common.nix`**: Base system packages, fonts, sudo, and nix daemon settings
- **`locales.nix`**: Timezone and locale configuration
- **`networking.nix`**: NetworkManager and firewall defaults
- **`cosmic.nix`, `gnome.nix`, `kde.nix`, `hyprland.nix`**: Desktop environment stacks

### Home Manager Modules (`home/modules/`)

Focused modules for individual tools:
- `git.nix`: Git identity and aliases
- `bash.nix`, `zsh.nix`: Shell configuration
- `ssh.nix`: SSH client settings
- `tmux.nix`: Terminal multiplexer config

## Best Practices

- Keep secrets out of the repository; use environment variables or external secret management
- Enable unfree packages explicitly per host with `nixpkgs.config.allowUnfree = true`
- Import only the modules you need in each host configuration
- Comment optional feature imports in host configs for documentation
- Use `nixos-hardware` profiles for tested hardware configurations
- Test configuration changes in a VM before deploying to production machines

## Home Manager Installation

If Home Manager is not yet available:

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
```

Then apply your configuration:

```bash
home-manager switch --flake .#joonas@<HOSTNAME>
```