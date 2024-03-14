{...}: {
  imports = [ ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "Joonas Tikkanen";
    userEmail = "joonas.tikkanen91@gmail.com";
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
