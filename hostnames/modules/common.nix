{ config, pkgs, ... }:

{
    security.sudo.wheelNeedsPassword = false;
    services.fwupd.enable = true;
    # SSH AGENT
    programs.ssh.startAgent = true;
    services.gnome.gcr-ssh-agent.enable = false;
    environment.systemPackages = with pkgs; [
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
        trusted-users = ["root joonas" "@wheel"];
        extra-substituters = https://devenv.cachix.org;
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=;
    };
    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
    ];
}