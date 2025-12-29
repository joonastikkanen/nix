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
    };
    };
    environment.systemPackages = with pkgs; [
            android-tools
            ansible
            argocd
            awscli2
            distrobox
            docker-compose
            bundler
            dbeaver-bin
            gcc
            gnumake
            google-cloud-sdk
            hugo
            hcloud
            kubectl
            kubectx
            kubecm
            kubeseal
            kubernetes-helm
            kustomize
            minikube
            minicom
            nodenv
            nodejs_24
            postman
            openbao
            qemu
            rake
            remmina
            ruby
            rubyPackages.nio4r
            screen
            talosctl
            tfswitch
            terraform
            vagrant
            virt-manager
            vscode
        ];
}
