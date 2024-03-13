{ config, pkgs, ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;

    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.30 homeassistant
      10.20.30.40 tikiproxy
      10.20.30.60 watermeter
    '';
  };
  systemd.services.NetworkManager-wait-online.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
   environment.systemPackages = with pkgs; [
    nfs-utils
    samba
   ];
}