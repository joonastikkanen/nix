{ config, pkgs, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
    virtualisation.libvirtd.enable = true; 
    environment.systemPackages = with pkgs; [
        android-tools
        ansible
        awscli2
        azure-cli
        gcc
        hugo
        podman
        podman-desktop
        podman-compose
        postman
        unstable.vscode
        qemu
        vagrant
        virt-manager
        dbeaver
        google-cloud-sdk
        nodenv
        nodejs_18
        helm
        kubectl
        remmina
        tfswitch
    ]
}