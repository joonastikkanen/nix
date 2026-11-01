{ pkgs, ... }:

let
  snapmakerOrca = pkgs.fetchurl {
    url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v2.4.1/Snapmaker_Orca-Linux-flatpak_V2.4.1_x86_64.flatpak";
    hash = "sha256-4rXSA8ECDvFycV2mTQfmHdE6Bs9iRus3fADjlDAbBOI=";
  };
in
{
  services.flatpak.enable = true;

  systemd.services.snapmaker-orca = {
    description = "Install Snapmaker Orca Flatpak";
    after = [ "flatpak.service" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    serviceConfig.Type = "oneshot";
    script = ''
      flatpak remote-add --if-not-exists --system flathub https://dl.flathub.org/repo/flathub.flatpakrepo
      flatpak install --system --noninteractive --or-update --reinstall ${snapmakerOrca}
    '';
  };
}
