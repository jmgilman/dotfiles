{ config, pkgs, ... }:

# All system packages
let syspkgs = [
  pkgs.asciinema
  pkgs.ansible
  pkgs.any-nix-shell
  pkgs.awscli2
  pkgs.bash
  pkgs.bash-completion
  pkgs.bitwarden-cli
  pkgs.chezmoi
  pkgs.consul
  pkgs.curl
  pkgs.diff-so-fancy
  pkgs.fzf
  pkgs.gh
  pkgs.git
  pkgs.gnupg
  pkgs.gnutls
  pkgs.go
  pkgs.google-cloud-sdk
  pkgs.lastpass-cli
  pkgs.jq
  pkgs.nano
  pkgs.navi
  pkgs.nodejs
  pkgs.oh-my-zsh
  pkgs.packer
  pkgs.poetry
  pkgs.postgresql
  pkgs.pre-commit
  pkgs.pure-prompt
  pkgs.python
  pkgs.redis
  pkgs.rustup
  pkgs.sqlite
  pkgs.terraform
  pkgs.thefuck
  pkgs.tldr
  pkgs.vault
  pkgs.wget
  pkgs.vim
  pkgs.zsh
];

in {
  # Default system configurations
  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;
  system.defaults.NSGlobalDomain.InitialKeyRepeat = 10;
  system.defaults.NSGlobalDomain.KeyRepeat = 1;
  system.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
  system.defaults.NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
  system.defaults.NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

  system.defaults.dock.autohide = true;
  system.defaults.dock.showhidden = true;

  system.defaults.finder.AppleShowAllExtensions = true;
  system.defaults.finder.FXEnableExtensionChangeWarning = false;
  system.defaults.finder.QuitMenuItem = true;

  # Program configuration

  programs.bash.enableCompletion = true;
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.nix-index.enable = true;
  programs.zsh.enable = true;

  # Environment configuration
  environment.variables.LANG = "en_US.UTF-8";

  # System packages
  environment.systemPackages = syspkgs;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.stateVersion = 4;
  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  # home-manager configuration
  imports = [ <home-manager/nix-darwin> ];
  users.users.josh = {
    name = "josh";
    home = "/Users/josh";
  };

  home-manager.users.josh = { pkgs, ... }: {
    # User-specific packages
    home.packages = [  ];

    # Enable direnv with nix support
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    # zsh configuration
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "ansible"
          "aws"
          "copydir"
          "copyfile"
          "copybuffer"
          "dirhistory"
          "fzf"
          "gh"
          "git"
          "macos"
          "sudo"
          "terraform"
          "web-search"
          "vscode"
        ];
        theme = "";
      };

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        count = "find . -type f | wc -l";
        ct = "column -t";
        cz = "chezmoi";
        cza = "chezmoi apply";
        czd = "cd ~/.local/share/chezmoi";
        cze = "chezmoi edit";
        czr = "chezmoi apply ~/.nixpkgs/darwin-configuration.nix darwin-update && exec $SHELL";
        j = "jobs -l";
        left = "ls -t -1";
        ll = "ls -la";
        lt = "du -sh * | sort -h";
        mount = "mount | grep -E ^/dev | column -t";
        now = ''date +"%T"'';
        ports = "sudo lsof -iTCP -sTCP:LISTEN -n -P";
        today = ''date +"%d-%m-%Y"'';
        vi = "vim";
      };

      plugins = [
        {
          name = "you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "1.7.3";
            sha256 = "/uVFyplnlg9mETMi7myIndO6IG7Wr9M7xDFfY1pG5Lc=";
          };
        }
      ];

      # Extra environment variables
      envExtra = ''
        # Load exports
        source $HOME/.exports
      '';

      # Extra content for .envrc
      initExtra = ''
        # Setup pyenv
        # eval "$(pyenv init --path)"
        # eval "$(pyenv init -)"

        # Setup pure
        fpath+=${pkgs.pure-prompt}/share/zsh/site-functions
        autoload -U promptinit; promptinit
        prompt pure
        zstyle :prompt:pure:path color green

        # Setup bitwarden
        eval "$(bw completion --shell zsh); compdef _bw bw;"

        # Setup Hashicorp autocompletion
        complete -o nospace -C ${pkgs.consul}/bin/consul consul
        complete -o nospace -C ${pkgs.packer}/bin/packer packer

        # Configure thefuck
        eval $(thefuck --alias)

        # Configure navi
        eval "$(navi widget zsh)"

        # Configure any-nix-shell
        any-nix-shell zsh --info-right | source /dev/stdin
      '';

      # Extra content for .envrc loaded before compinit()
      initExtraBeforeCompInit = ''
        # Add completions
        fpath+=${pkgs.chezmoi}/share/zsh/site-functions
        fpath+=${pkgs.google-cloud-sdk}/share/zsh/site-functions
        fpath+=${pkgs.poetry}/share/zsh/vendor-completions
        fpath+=/opt/homebrew/share/zsh/site-functions
      '';
    };
  };
}
