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
  pkgs.packer
  pkgs.poetry
  pkgs.postgresql
  pkgs.pre-commit
  pkgs.python
  pkgs.redis
  pkgs.rustup
  pkgs.sqlite
  pkgs.terraform
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

  # Environment configuration
  environment.loginShell = "${pkgs.bash}/bin/bash";
  environment.variables.SHELL = "${pkgs.bash}/bin/bash";
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
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  nix.extraOptions = ''
    extra-platforms = aarch64-darwin x86_64-darwin
    experimental-features = nix-command flakes
  '';
}
