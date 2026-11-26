{
  # Declaratively manage Homebrew via nix-darwin (packages stay on Brew).
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = false;
      upgrade = true;
    };

    taps = [
      {
        name = "go-musicfox/go-musicfox";
        trusted = true;
      }
      {
        name = "chen08209/tap";
        trusted = true;
      }
    ];

    brews = [
      "bat"
      "bob"
      "btop"
      "cava"
      "eza"
      "fastfetch"
      "fzf"
      "ghostscript"
      "go-musicfox/go-musicfox/go-musicfox"
      "jq"
      "lazygit"
      "p7zip"
      "pipes-sh"
      "pngpaste"
      "ripgrep"
      "sevenzip"
      "starship"
      "stow"
      "tmux"
      "tree-sitter"
      "tree-sitter-cli"
      "tty-clock"
      "typst"
      "unar"
      "yazi"
      "zoxide"
      "zsh-autosuggestions"
      "zsh-completions"
      "zsh-syntax-highlighting"
    ];

    casks = [
      "font-jetbrains-mono"
      "font-maple-mono-nf-cn"
      "font-sf-pro"
      "input-source-pro"
      "keycastr"
      "kitty"
      "omniwm"
      "obsidian"
      "flclash"
      "libreoffice"
    ];
  };
}
