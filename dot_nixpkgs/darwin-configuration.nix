{ config, pkgs, ... }:
let syspkgs = [
  pkgs.ansible
  pkgs.asciinema
  pkgs.awscli2
  pkgs.bash
  pkgs.bash-completion
  pkgs.bitwarden-cli
  pkgs.chezmoi
  pkgs.consul
  pkgs.curl
  pkgs.git
  pkgs.gnupg
  pkgs.gnutls
  pkgs.go
  pkgs.google-cloud-sdk
  pkgs.lastpass-cli
  pkgs.jq
  pkgs.nano
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
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.variables.LANG = "en_US.UTF-8";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = syspkgs;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  # programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';

  # Home Manager
  imports = [ <home-manager/nix-darwin> ];
  users.users.josh = {
    name = "josh";
    home = "/Users/josh";
  };

  home-manager.users.josh = { pkgs, ... }: {
    home.packages = [  ];
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
          "git"
          "macos"
          "sudo"
          "terraform"
          "web-search"
          "vscode"
        ];
        theme = "";
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

      envExtra = ''
        # Load exports
        source .exports
      '';

      initExtra = ''
        # Setup pyenv
        eval "$(pyenv init --path)"
        eval "$(pyenv init -)"

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
      '';

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
