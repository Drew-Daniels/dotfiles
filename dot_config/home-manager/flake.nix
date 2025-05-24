{
  description = "Home Manager Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeConfigurations = {
      # NOTE: 'nixos' here is my user's name
      drew = home-manager.lib.homeManagerConfiguration {
        # Use the following on MacOS M1
        # system = "aarch64-darwin"
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [./home.nix];
      };
    };
  };
}
