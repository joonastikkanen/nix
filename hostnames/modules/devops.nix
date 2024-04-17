{ config, pkgs, ... }:

{

    # Minimal configuration for NFS support with Vagrant.
    services.nfs.server.enable = true;

    # Add firewall exception for libvirt provider when using NFSv4 
    networking.firewall.interfaces."virbr1" = {                                   
        allowedTCPPorts = [ 2049 ];                                               
        allowedUDPPorts = [ 2049 ];                                               
    };  
    virtualisation.docker.enable = true;
    virtualisation.docker.rootless = {
        enable = true;
        setSocketVariable = true;
    };
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
        argocd
        awscli2
        azure-cli
        gcc
        hugo
        postman
        vscode
        qemu
        vagrant
        virt-manager
        dbeaver
        google-cloud-sdk
        minikube
        nodenv
        nodejs_18
        kubernetes-helm
        kubectl
        kubectx
        remmina
        tfswitch
        terraform
    ];
}
