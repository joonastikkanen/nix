{ config, pkgs, ... }:

{
    virtualisation.libvirtd = {
    enable = true;
    qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
        }).fd];
        };
    };
    };
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
        vscode
        qemu
        vagrant
        virt-manager
        dbeaver
        google-cloud-sdk
        nodenv
        nodejs_18
        kubernetes-helm
        kubectl
        remmina
        tfswitch
        terraform
    ];
}
