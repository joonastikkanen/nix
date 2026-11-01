{ config, pkgs, ... }:

{
  services.displayManager.sddm.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    elisa
  ];
  environment.sessionVariables.TERMINAL = "konsole";
  environment.etc."xdg/kdeglobals".text = ''
    [General]
    TerminalApplication=konsole
    TerminalService=org.kde.konsole.desktop
  '';
}
