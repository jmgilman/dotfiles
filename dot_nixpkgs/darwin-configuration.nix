{ config, pkgs, ... }:
let syspkgs = [
  pkgs.ansible
  pkgs.asciinema
  pkgs.awscli2
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
