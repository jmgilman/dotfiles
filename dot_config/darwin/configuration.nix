{ config, pkgs, ... }:

# All system packages
let
syspkgs = [
  pkgs.asciinema
  pkgs.ansible
  pkgs.any-nix-shell
  pkgs.autojump
  pkgs.awscli2
  pkgs.bat
  pkgs.bat-extras.batman
  pkgs.bat-extras.batgrep
  pkgs.bat-extras.batdiff
  pkgs.bat-extras.batwatch
  pkgs.bat-extras.prettybat
  pkgs.bitwarden-cli
  pkgs.chezmoi
  pkgs.consul
  pkgs.curl
  pkgs.diff-so-fancy
  pkgs.fd
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
  pkgs.python310
  pkgs.redis
  pkgs.ripgrep
  pkgs.rustup
  pkgs.shellcheck
  pkgs.shfmt
  pkgs.sqlite
  pkgs.terraform
  pkgs.thefuck
  pkgs.tldr
  pkgs.vault
  pkgs.wget
  pkgs.vim
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
}
