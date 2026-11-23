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

### Install on a fresh NixOS system

Start from an installed, bootable NixOS system with internet access and a user
with `sudo` access. Run these commands on that system, not in the installer.
The example below uses the `linux` host and the `joonas` user. Other existing
hosts are `matebook`, `work`, `tikinas`, and `homeassistant`.

#### 1. Clone the repository

Git can be used temporarily before the repository's packages are installed:

```bash
mkdir -p ~/Documents/git
cd ~/Documents/git
nix-shell -p git --run 'git clone https://github.com/joonastikkanen/nix.git'
cd nix
export HOST=linux
```

Use the repository directory for all commands below. The first commands enable
flakes explicitly; the shared configuration enables them permanently afterward.

#### 2. Adapt the configuration to the machine

Keep a copy of the working installation configuration, then generate hardware
settings for this machine:

```bash
sudo cp -a /etc/nixos /etc/nixos.before-flake
sudo nixos-generate-config --show-hardware-config > "hostnames/$HOST/hardware-configuration.nix"
```

Edit `hostnames/$HOST/configuration.nix` before building:

- Keep the boot loader settings appropriate for the installed system; copy them
  from `/etc/nixos/configuration.nix` where necessary.
- Adjust hardware-specific imports (GPU modules and nixos-hardware profiles),
  networking, and any extra disk mounts. In particular, the `linux` profile
  imports the AMD GPU module and mounts disks labelled `DATA` and `Barracuda`;
  remove or adapt those entries if the machine does not have them.
- Set `networking.hostName` to the selected hostname.
- Keep `system.stateVersion` at the value from the fresh installation's
  `/etc/nixos/configuration.nix`. It is not the package release selector.
- The profiles configure the `joonas` account. If using another username, adapt
  the user definition, automatic login settings, `home.username`,
  `home.homeDirectory`, and the corresponding Home Manager output in `flake.nix`.

For a new hostname, follow [Adding a New Host](#adding-a-new-host) first.
The existing Home Manager outputs target `x86_64-linux`.

#### 3. Build and activate NixOS

```bash
sudo nixos-rebuild build --flake "path:.#$HOST" --option experimental-features 'nix-command flakes'
sudo nixos-rebuild switch --flake "path:.#$HOST" --option experimental-features 'nix-command flakes'
```

`path:.` includes newly added configuration files. These commands use the pinned
dependencies in `flake.lock`; an update is not needed for installation.

If `joonas` is a newly created account, set its password:

```bash
sudo passwd joonas
```

Reboot to load the configured kernel and desktop, then log in as the configured
user. If you cloned the repository as a different user, clone it into this
user's home directory as well and transfer your adapted configuration files.

#### 4. Activate Home Manager

Home Manager is separate from the NixOS configuration. As the target user
(`joonas` in this example), open the repository and run **without sudo**:

```bash
cd ~/Documents/git/nix
export HOST=linux
nix build "path:.#homeConfigurations.joonas@$HOST.activationPackage" --out-link result-home
./result-home/activate
```

This bootstraps Home Manager using the version pinned by this flake. If activation
reports conflicting existing dotfiles, move those files aside and rerun
`./result-home/activate`. The configuration enables the `home-manager` command
for subsequent updates. Open a new login session after activation.

#### 5. Subsequent updates

```bash
task switch           # Apply local NixOS configuration changes
task home             # Apply local Home Manager changes
task upgrade          # Update flake.lock, then build and activate NixOS
task home             # Apply Home Manager with the updated dependencies
```

Tasks default to the current hostname and username. Override them when needed,
for example `task home HOST=linux USER_NAME=joonas`.

### Task Runner

The shared system packages include Task (`go-task`, providing the `task` binary).
From this repository:

```bash
task                  # List available tasks
task check            # Check the flake without building
task build            # Build this machine's NixOS configuration
task switch           # Apply this machine's NixOS configuration (sudo)
task home             # Apply this user's Home Manager configuration
task update           # Update flake.lock without activating changes
task upgrade          # Update flake.lock and apply this machine's NixOS configuration (sudo)
task build HOST=matebook
task home HOST=matebook USER_NAME=joonas
```

Tasks use `path:.` to include new, untracked configuration files. Review your
working-tree changes before running `task switch` or `task home`.

### GNOME desktop (`linux`)

The `linux` host uses GNOME on Wayland with GDM and automatic login. Its Home
Manager profile configures an Ubuntu-inspired dark desktop with Yaru themes,
icons and cursors, Ubuntu fonts, a purple wallpaper, the GNOME top bar, and an
always-visible left dock (Dash to Dock). It includes tray icons (including
Nextcloud) and **Ctrl+Alt+T** for GNOME Console. New
terminals use Zsh with Oh My Zsh, Powerlevel10k, suggestions, syntax highlighting,
and history search with the arrow keys.

GNOME hosts use the GCR SSH agent and GNOME Keyring. The agent socket is
`$XDG_RUNTIME_DIR/gcr/ssh`; inherited SSH-forwarded sockets are preserved.
The `linux` Home Manager profile selects the existing `.sshkey` identity and
links its public key under the matching `.sshkey.pub` name so GCR can discover
it automatically. Private keys remain in `~/.ssh`, outside the Nix store.

Automatic login cannot unlock a password-protected login keyring by itself.
Unlock it when prompted on first use; SSH key passphrases can be remembered in
the keyring. **Passwords and Keys** (Seahorse) manages the keyring.

When changing desktop environments, prepare the system for the next boot and
apply the user settings, then reboot when ready:

```bash
sudo nixos-rebuild boot --flake path:.#linux
task home HOST=linux
```

After logging into GNOME, check `echo "$SSH_AUTH_SOCK"`, `ssh-add -l`, and
`systemctl --user status gcr-ssh-agent.socket gcr-ssh-agent.service`.

### Building a NixOS Configuration

```bash
sudo nixos-rebuild switch --flake 'path:.#<HOSTNAME>'
```

Replace `<HOSTNAME>` with your target machine (e.g., `linux`).

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

For the first activation, follow [Activate Home Manager](#4-activate-home-manager)
above. This uses the flake's pinned Home Manager version and requires no channels.
Afterward, use `task home` from the repository.
