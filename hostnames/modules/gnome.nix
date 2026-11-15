{ config, pkgs, ... }:

{
    services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
        gnome.gnome-keyring.enable = true;
        gnome.gcr-ssh-agent.enable = true;
    };

    # GCR integrates SSH passphrases with GNOME Keyring and its graphical prompts.
    programs.ssh.startAgent = false;
    programs.seahorse.enable = true;
    environment.sessionVariables.TERMINAL = "kgx";
    environment.extraInit = ''
        # Keep forwarded agents when logging in over SSH.
        if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
            export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
        fi
    '';
    services.xserver = {
        enable = true;
        xkb.variant = "";
        xkb.layout = "fi";

        excludePackages = with pkgs; [
            xterm
        ];
    };

    services.libinput = {
        enable = true;
        # disabling mouse acceleration
        mouse = {
            accelProfile = "flat";
        };
    };

    environment.systemPackages = with pkgs; [
        gnomeExtensions.appindicator
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.user-themes
        gnomeExtensions.vitals
        gnomeExtensions.blur-my-shell
        gnomeExtensions.auto-move-windows
        gnomeExtensions.dash-to-dock
        gnome-tweaks
        polkit_gnome
        gparted
    ];
}
