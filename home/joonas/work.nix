{...}: {
  imports = [
    ../modules/bash.nix
    ../modules/firefox.nix
    ../modules/ssh.nix
    ../modules/tmux.nix
   ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Joonas Tikkanen";
    userEmail = "joonas.tikkanen@kinetive.fi";
    extraConfig = {
      pull.rebase = "true";
    };
  };

  home = {
    username = "joonas";
    homeDirectory = "/home/joonas";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
