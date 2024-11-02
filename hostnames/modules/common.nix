{ config, pkgs, ... }:

{
    programs.ssh.startAgent = true;
    security.sudo.wheelNeedsPassword = false;
    services.fwupd.enable = true;
    environment.systemPackages = with pkgs; [
        async
        curl
        dnsutils
        file
        git
        htop
        inetutils
        jq
        localsend
        ncdu
        neofetch
        nmap
        nnn
        openssl
        pciutils
        tmux
        tree
        unrar
        unzip
        usbutils
        vim
        wget
        yq
    ];
    nix.settings = {
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
    };
    nix.extraOptions = ''
        trusted-users = root joonas
    '';
    nix.extraOptions = ''
        extra-substituters = https://devenv.cachix.org;
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
    '';
}