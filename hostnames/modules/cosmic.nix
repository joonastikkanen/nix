{ config, pkgs, ... }:

{
  # Enable GDM
  services.displayManager.gdm.enable = true;

  # Disable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = false;

  # SSH Agent - GNOME Keyring integration for COSMIC
  programs.ssh.startAgent = false;  # Let gnome-keyring handle the agent
  services.gnome.gnome-keyring.enable = true;
  
  # Ensure PAM integration for automatic unlock
  security.pam.services.gdm.enableGnomeKeyring = true;
  
  # Auto-start ssh component of gnome-keyring
  environment.systemPackages = with pkgs; [
    seahorse  # GUI for managing keys
    gnome-keyring  # Ensure gnome-keyring is available
  ];

  # Explicitly enable SSH component in gnome-keyring
  programs.dconf.enable = true;
  
  # Set environment variables for SSH authentication socket
  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"
    fi
  '';

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;
}