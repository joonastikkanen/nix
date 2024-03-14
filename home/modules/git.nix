{...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    userName = "Joonas Tikkanen";
    userEmail = "joonas.tikkanen91@gmail.com";
    extraConfig = {
      pull.rebase = "true";
    };
  };
}
