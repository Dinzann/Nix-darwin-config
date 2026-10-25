{
  description = "Dinzann nix-darwin system flake";

  inputs = {
    # 国内 git 镜像拉取 nixpkgs（不依赖 GitHub）
    nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixpkgs-unstable&shallow=1";
    # 已 lock 后日常 rebuild 不必重拉；更新此 input 时仍需访问 GitHub
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

          # nix.enable=false 时此处 settings 不会写入 /etc/nix。
          # 二进制缓存见 modules/nix.custom.conf + scripts/install-mirrors.sh
          nix.settings.experimental-features = "nix-command flakes";

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
