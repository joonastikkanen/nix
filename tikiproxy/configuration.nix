{ config, pkgs, lib, ... }:
{
  imports =
    [
      #./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

 swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 2*1024;
  } ];

  networking = {
    hostName = "tikiproxy";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8123 22 ];
    };
    interfaces.end0.ipv4.addresses = [ {
      address = "10.20.30.40";
      prefixLength = 24;
    } ];
    defaultGateway = "10.20.30.1";

    nameservers = [ "1.1.1.1" "10.20.30.20" ];

    extraHosts = ''
      10.20.30.20 tikinas
    '';
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "wheel" "docker" ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  virtualisation.docker.enable = true;
  console.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    ansible
    curl
    docker-compose
    vim
    wget
    neofetch
    git
    nfs-utils
    openssl
    samba
    unzip
    unrar
  ];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
