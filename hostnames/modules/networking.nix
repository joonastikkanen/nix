{ config, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.55 homeassistant
      10.20.30.46 ambwks501
      10.20.30.60 ollama
    '';
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
   environment.systemPackages = with pkgs; [
    nfs-utils
    samba
    openconnect
    networkmanager-openconnect
    networkmanagerapplet
    networkmanager-openvpn
   ];
}
