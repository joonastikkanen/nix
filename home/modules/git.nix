{...}: {
  # Install git via home-manager module
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joonas Tikkanen";
        email = "joonas.tikkanen91@gmail.com";
      };
      pull.rebase = "true";
    };
  };
}
