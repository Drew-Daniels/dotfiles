{
  description = "NixOS Configuration Flake";

  inputs = {
    # https://search.nixos.org/packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    # nixpkgs-fd40cef8d.url = "github:nixos/nixpkgs/fd40cef8d797670e203a27a91e4b8e6decf0b90c";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    # nixpkgs-stable,
    # nixpkgs-fd40cef8d,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          # pkgs-stable = import nixpkgs-stable {
          #   inherit system;
          # };
          # nixpkgs-fd40cef8d = import nixpkgs-fd40cef8d {
          #   inherit system;
          # };
        };
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            # https://discourse.nixos.org/t/home-manager-useuserpackages-useglobalpkgs-settings/34506/4
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;

            home-manager.users.drew = import ./home.nix;
            # home-manager.backupFileExtension = "backup";
            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          }
        ];
      };
    };
  };
}
