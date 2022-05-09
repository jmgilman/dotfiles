{ config, pkgs, machnix, ... }:
let
    gopass = pkgs.callPackage ./packages/gopass.nix {};
in {
    # User-specific packages
    home.packages = [
        gopass
        pkgs.asciinema
        pkgs.ansible
        pkgs.any-nix-shell
        pkgs.autojump
        pkgs.awscli2
        pkgs.bitwarden-cli
        pkgs.certbot-full
        pkgs.chezmoi
        pkgs.consul
        pkgs.diff-so-fancy
        pkgs.gh
        pkgs.google-cloud-sdk
        pkgs.jdk11
        pkgs.lastpass-cli
        pkgs.maven
        pkgs.navi
        pkgs.nixos-generators
        pkgs.oh-my-zsh
        pkgs.packer
        pkgs.php
        pkgs.poetry
        pkgs.postgresql
        pkgs.pre-commit
        pkgs.pure-prompt
        pkgs.redis
        pkgs.rustup
        pkgs.shellcheck
        pkgs.shfmt
        pkgs.sqlite
        pkgs.terraform
        pkgs.thefuck
        pkgs.tldr
        pkgs.vault
    ];

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
                "ssh-agent"
                "sudo"
                "terraform"
                "web-search"
                "vscode"
            ];
            theme = "";
            extraConfig = ''
                zstyle :omz:plugins:ssh-agent lazy yes
            '';
        };

        shellAliases = {
            ".." = "cd ..";
            "..." = "cd ../..";
            brg = "batgrep";
            cat = "bat --paging=never";
            count = "find . -type f | wc -l";
            ct = "column -t";
            cz = "chezmoi";
            cza = "chezmoi apply";
            czd = "cd ~/.local/share/chezmoi";
            cze = "chezmoi edit";
            czr = "chezmoi apply ~/.config/darwin darwin-update && exec $SHELL";
            gbc = "git checkut -b ";
            gpb = ''git push origin "$(git rev-parse --abbrev-ref HEAD)"'';
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

        # Configure autojump
        source ${pkgs.autojump}/share/zsh/site-functions/autojump.zsh
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
}