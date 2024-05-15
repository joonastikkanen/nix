# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../modules/common.nix
      ../modules/gnome.nix
      ../modules/locales.nix
      ../modules/sound.nix
      #../modules/nvidia.nix
      ../modules/amd-gpu.nix
      ../modules/networking.nix
      ../modules/tailscale.nix
      ../modules/gaming.nix
    ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/mnt/DATA" =
    { device = "/dev/disk/by-label/DATA";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000" "gid=1000" ];
    };

  fileSystems."/mnt/TIKINAS" = {
    device = "10.20.30.20:/data";
    fsType = "nfs";
  };

  networking.hostName = "joonas-linux";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joonas = {
    isNormalUser = true;
    description = "Joonas Tikkanen";
    extraGroups = [ "networkmanager" "wheel" "kvm" "input" "disk" "libvirtd" ];
  };

  programs.ssh.startAgent = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.ovmf.enable = true;
    qemu.runAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  # CHANGE: add your own user here
  users.groups.libvirtd.members = [ "root" "joonas"];
  
  #     ls /nix/store/*OVMF*/FV/OVMF{,_VARS}.fd | tail -n2 | tr '\n' : | sed -e 's/:$//'
  # to find your nix store paths
  virtualisation.libvirtd.qemu.verbatimConfig = ''
    nvram = [
      "/nix/store/g500pnrjg12cg7dbznvl9hylik19cnav-OVMF-202311-fd/FV/OVMF.fd:/nix/store/g500pnrjg12cg7dbznvl9hylik19cnav-OVMF-202311-fd/FV/OVMF_VARS.fd"
    ]
  '';

  systemd.tmpfiles.rules = [
    "f /dev/shm/scream 0660 joonas qemu-libvirtd -"
    "f /dev/shm/looking-glass 0660 joonas qemu-libvirtd -"
  ];

  systemd.user.services.scream-ivshmem = {
    enable = true;
    description = "Scream IVSHMEM";
    serviceConfig = {
      ExecStart = "${pkgs.scream}/bin/scream-ivshmem-pulse /dev/shm/scream";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
    requires = [ "pulseaudio.service" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
  	"electron-24.8.6"
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
    bitwarden
    discord
    unstable.enpass
    flatpak
    fondo
    freetype
    gcc
    gimp
    go
    google-chrome
    gparted
    hugo
    hunspellDicts.sv_FI
    kid3
    libreoffice
    pavucontrol
    python311
    python311Packages.pip
    qemu
    awscli2
    scream
    spotify
    teamspeak_client
    telegram-desktop
    terraform
    tfswitch
    unstable.whatsapp-for-linux
    virt-manager
    vlc
    vscode
  ];

  system = {
    stateVersion = "23.05";
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
  };

}

