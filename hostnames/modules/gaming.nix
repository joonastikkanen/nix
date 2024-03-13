{ config, pkgs, ... }:
{
    programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

    environment.systemPackages = with pkgs; [
      steam
      steam-run
      vulkan-tools
      lutris
      (lutris.override {
            extraPkgs = pkgs: [
        # List package dependencies here
              wineWowPackages.stable
              winetricks
            ];
          })
    ]
}