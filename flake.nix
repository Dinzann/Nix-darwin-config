{
  description = "Dinzann nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # Determinate Nix manages the daemon; leave nix-darwin's Nix module off.
          nix.enable = false;

          nixpkgs.hostPlatform = "aarch64-darwin";

          # Needed by homebrew.* and other user-scoped options.
          system.primaryUser = "dinzann";

          environment.systemPackages = [
            pkgs.nixfmt
          ];

          security.pam.services.sudo_local.touchIdAuth = true;

          nix.settings.experimental-features = "nix-command flakes";

          nix.settings.substituters = [
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
            "https://cache.nixos.org/"
          ];

          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 6;
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild switch --flake ~/.config/nix-darwin#Dinzann
      darwinConfigurations."Dinzann" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          ./modules/homebrew.nix
        ];
      };
    };
}
