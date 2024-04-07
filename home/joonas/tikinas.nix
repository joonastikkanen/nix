{...}: {
  imports = [
    ../modules/git.nix
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

  home = {
    username = "joonas";
    homeDirectory = "/home/joonas";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  home.file = { "/home/joonas/.cloudflared/config.yaml" = { 
    text = '''
      tunnel: 1e9e73df-93b3-444a-ba1f-74a62b11f36a
      credentials-file: /home/joonas/.cloudflared/creds.json

      ingress:
        - hostname: nextcloud.joonastikkanen.fi
          service: http://localhost:8080
        - hostname: jellyfin.joonastikkanen.fi
          service: http://localhost:8096
        - hostname: ai.joonastikkanen.fi
          service: http://localhost:3002
        - hostname: immich.joonastikkanen.fi
          service: http://localhost:2283
    ''';
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
