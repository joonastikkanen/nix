{
  description = "NixOS configs for my machines";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-26-05.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-26.05";
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
      linux = nixosSystemFor "linux" ./hostnames/linux/configuration.nix;
      matebook = nixosSystemFor "matebook" ./hostnames/matebook/configuration.nix;
      work = nixosSystemFor "work" ./hostnames/work/configuration.nix;
      tikinas = nixosSystemFor "tikinas" ./hostnames/tikinas/configuration.nix;
      homeassistant = nixosSystemFor "homeassistant" ./hostnames/homeassistant/configuration.nix;
    };

    homeConfigurations = {
      "joonas@linux" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "linux");
      "joonas@matebook" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "matebook");
      "joonas@work" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "work");
      "joonas@tikinas" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "tikinas");
      "joonas@homeassistant" = home-manager.lib.homeManagerConfiguration (homeManagerFor "joonas" "homeassistant");
    };
  };
}
