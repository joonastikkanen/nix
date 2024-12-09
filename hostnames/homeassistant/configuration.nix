{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ../modules/common.nix
      ../modules/locales.nix
      ../modules/ssh.nix
      ../modules/tailscale.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  fileSystems."/mnt/TIKINAS" = {
    device = "10.20.30.20:/data";
    fsType = "nfs";
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  
  networking = {
    hostName = "homeassistant";
    networkmanager.enable = true;
    firewall = {
      allowPing = true;
      enable = true;
      allowedTCPPorts = [ 22 8123 40000 6052 8080 ];
      allowedUDPPorts = [ 5683 1900 46981 6666 6667 57904 5353 ];
    };
    interfaces.enp0s31f6.ipv4.addresses = [ {
      address = "10.20.30.30";
      prefixLength = 24;
    } ];
    defaultGateway = "10.20.30.1";

    nameservers = [ "1.1.1.1" ];

    extraHosts = ''
      10.20.30.20 tikinas
      10.20.30.40 tikiproxy
    '';
  };

  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAklY2OI4S534W3JzBM0oUhTIGTNnVIFrcypkgN4THczMm/6tnPgw9tkEPJqPrWGto2mgUhrYx18cXe+hTZLCCK+TIlXok60PosunQtZ1CIcUe30IhE927nFAUz+otN9KolyeuMKhsPK9Ei/0ZSvh4K79JwPUTi5KnZqwOnjnxlkMz/pz8pYQSGahi4H4QnRxutdchb4T8ycXrZvk1tlYVef1RnKebfvbfNb9aFx644N5+GaHGr/HwEaWLdurQMEb/h8zh1kNc7Dzfk3iGSnJvHri0AEtbr0GmI3r4Iofzgw5Ix+5hbU2+AZtNistA6+IeBG5fJgpn6On1qS7sAVgsWw== joonas.tikkanen91@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA5VgOodGHpCrSSAPik03K3XRCGzEoDR3383h6UPsgjWQNALPGfqpJIF48Qv9SPZDIYqoBAE/kYd5v2wcMjpKVpNUnHmx8gc7fA3mvs2uSV8azrxwk5LI7vRdcKzoyg3tiy6VwJR2UMcfTMwiZD168DYJvlsPl1+Q7PUfWNfisMBpJMzY76jrB/GUn9wvGL1Ywh6Gj2Psz1hm4/gKGkthvAYnMZnBp5BYGnLjhxjWxaxQK7gBqAb3xyRWIgQJVnSJnBnbNrkOS9lzgEnhR9/jy8iBPH8ilcWuLq/cYA1aGVkHWT1tmXtMEz4+BWrUdpS5pHEOk5m9WkcE3stb6ofqADQ== joonas.tikkanen@ambientia.fi"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDB/iCK0H72AADyoPibhv9VlV4FUojUX4+JrbL4dhmIu+q7khEbTrsLQd2Y66i1Wuefvc9+Xu7IyZf4ItnauowNCBvgdo8jo4D2JcaUnc8W9WpGW5XxKSQkIYr7IbAYHr/iSMgTX9d8Sl/UpDtcafrZb8NMVsgP99V84MjE9X844AAcw4Pd7ZArOCPjxnwgDLlDjEoauKiecQyx++OJNZY3/Ff8cYeQ5+cOQ+EdYBzNmLMOVIlh+1J/Zuv3R/5A3H7JO7zJaj0eYL+18HzVS8apw3lIUe+dRj7V9vrb74XkKKazuUEGlXsa2tsYNlv2ia2sPE0Xsuy1sQPM/g9OgSVU6K0EhIJIiqddUbe1tWgu2bieym82VVWq7u1rLuWh3PI5C9c3y+wCzyTkAEc8GhaV25+TotTlcp3O4htk3WiZOVz77NC6XRkd77laAGbn50weLiks1q3RT4eQRso3RuFFgF8bpcI8Kn9Ya5nkibyd88Vrca3Jp2vawC5zrWAKA19J/Zsaf6FI7fiqcyslifTVfzh26sbFKYR64XG9CvosQrstQxrt0XPuxZD/SwwnDNHo5p4uIbekWHvdxpAn3U1dNu2FmI/fn1AsI2/XnseOI/Si6f9u+gDkx89dOQ2Ll9rsAaN3O8m5nRca+RrhiAALX0j5wo44R3KSJrZeZnOBw== joonas.tikkanen91@gmail.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqHs+juS5reVO9nN3LtjbGpvLbYMowkiadHFLb3eEMvRCHulFrKcryeZZbsfJZ6Dmi26ptuUCLFTqhaI9B4AefPcdmNH9qjuYnkafXp2X+/8tvFrxp8iys7MnOv0oG/a5UtAJ5KBMBsQhXcqmvez2MZnaasAzy9R+w8BTXy0MExoylb7W/m0BY4ek1KrPdvcdnmr7spcDM/cbF+EtUTNE4qnMk6y2Ag2UWYiwsP9Wt6GISucKX/UvmTcVV8mpt9gHDtLHeohGUW/A9EqWTDYnvtz1uJ3Sl679AM5vSG7kVhp8FxEkoV6OiK0/TsOOzWpM0oMlLs+S9aD6VF70bYuqvKTOuvSFEbG1uijGA7FAeOcE8AX6Lo4N72BF6Tkl90sqWPYx5061i2R3Hhtghf0r71UVoAVgna6J5+FxEUKAd4s7k+PRGHWHWQeHJG8GURea0VoTzsz+DnU26Qf0EFhPGoM2C0OfyRisVYWP4CL37BkIh9nkSjUbgkZ2OcAdp9e8= matebook"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9lCCDggJV1Xe8j/LfL80asF90L4NvnjwGwP0TrrMS3 joonas.tikkanen@kinetive.fi"
    ];
  };

  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = { };
  systemd.services.clourflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiNGQzOGFjYmIwYmQyODQ5MmNhZDRjM2Y3ZmM5ZDk0MzUiLCJ0IjoiYjI4ZmY0YTktOGNkNy00M2FiLThiNjYtYTQ2OWUwYjgyM2Q3IiwicyI6Ik56Vm1ObUV3T1RrdE5EZGhZUzAwWlRObExXSXdPREV0WXpBek1ERTRNMlJpTWpVMCJ9";
      Restart = "always";
      User = "cloudflared";
      Group = "cloudflared";
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  console.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ansible
    cloudflared
    curl
    docker-compose
    git
    python311Packages.zigpy
    python311Packages.pip
    python311Packages.virtualenv
    htop
    jq
    neofetch
    nfs-utils
    netdata
    openssl
    python3
    sqlite
    samba
    tmux
    unzip
    unrar
    usbutils
    vim
    wget
    yq
  ];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.05";
}
