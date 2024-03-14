{...}: {
  imports = [
    ../modules/git.nix
  ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "joonas.tikkanen@kinetive.fi";
  };

  home = {
    username = "joonas";
    homeDirectory = "/home/joonas";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
