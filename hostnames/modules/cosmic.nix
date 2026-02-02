{ config, pkgs, ... }:

{
  # Enable GDM
  services.displayManager.gdm.enable = true;

  # Disable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = false;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # This tells the system where to look for the SSH auth socket
  environment.variables.SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";
  
  # Auto-start ssh component of gnome-keyring
  environment.systemPackages = with pkgs; [
    seahorse  # GUI for managing keys
    gnome-keyring  # Ensure gnome-keyring is available
  ];

  # System76 scheduler
  services.system76-scheduler.enable = true;

  # Clipboard
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;
}