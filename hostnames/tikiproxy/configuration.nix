{ config, pkgs, lib, ... }:
{
  imports =
    [
      #./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/locales.nix
      ../../modules/ssh.nix
      ../../modules/tailscale.nix
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

  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "wheel" "docker" ];
  };

  virtualisation.docker.enable = true;
  programs.bash.loginShellInit = "screenfetch";
  console.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    ansible
    curl
    docker-compose
    neofetch
    nfs-utils
    openssl
    samba
  ];

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
