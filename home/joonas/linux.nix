{...}: {
  imports = [
    ../modules/git.nix
    ../modules/bash.nix
    ../modules/zsh.nix
    ../modules/firefox.nix
    ../modules/freecad-mcp.nix
    ../modules/ssh.nix
    ../modules/tmux.nix
  ];

  # nixpkgs configuration
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "joonas";
    homeDirectory = "/home/joonas";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Keep the existing Firefox profile location used by this Home Manager state.
  programs.firefox.configPath = ".mozilla/firefox";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
