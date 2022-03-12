{ config, pkgs, ... }:

# All system packages
let

yubikey-manager = pkgs.yubikey-manager.overrideAttrs (_: {
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'cryptography = "^2.1 || ^3.0"' 'cryptography = "*"'
  '';
});

syspkgs = [
  pkgs.bat
  pkgs.bat-extras.batman
  pkgs.bat-extras.batgrep
  pkgs.bat-extras.batdiff
  pkgs.bat-extras.batwatch
  pkgs.bat-extras.prettybat
  pkgs.curl
  pkgs.direnv
  pkgs.fd
  pkgs.fzf
  pkgs.git
  pkgs.gnupg
  pkgs.gnutls
  pkgs.go
  pkgs.jq
  pkgs.nano
  pkgs.nodejs
  pkgs.openssh
  pkgs.pcsclite
  pkgs.pinentry_mac
  pkgs.procps
  pkgs.python310
  pkgs.ripgrep
  pkgs.vim
  pkgs.wget
  yubikey-manager
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
  programs.gnupg.agent.enableSSHSupport = false;
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
