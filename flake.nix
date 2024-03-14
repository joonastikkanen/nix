{
  description = "NixOS configs for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS profiles to optimize settings for different hardware
    hardware.url = "github:nixos/nixos-hardware";

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;

    # Function for NixOS system configuration
    nixosSystemFor = hostname: configurationFile:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [configurationFile];
      };

    # Function for Home Manager configuration
    homeManagerFor = user: hostname: {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./home/${user}/${hostname}.nix];
    };
  in {
    nixosConfigurations = {
      joonas-linux = nixosSystemFor "joonas-linux" ./hostnames/joonas-linux/configuration.nix;
      matebook = nixosSystemFor "matebook" ./hostnames/matebook/configuration.nix;
      work = nixosSystemFor "work" ./hostnames/work/configuration.nix;
    };

    homeConfigurations = {
      "joonas@joonas-linux" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "joonas-linux");
      "joonas@matebook" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "matebook");
      "joonas@work" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "work");
    };
  };
}
