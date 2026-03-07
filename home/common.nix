# home/common.nix — shared configuration for all machines.
#
# This module is imported by every machine configuration. It defines
# everything that should be consistent everywhere: zsh, neovim, tmux,
# fzf, oh-my-posh, and shared packages.

{ config, pkgs, lib, ... }:

{
  # ---------------------------------------------------------------------------
  # Home-manager basics
  # ---------------------------------------------------------------------------

  # home.username and home.homeDirectory are set in each machine file
  # since the path differs between Linux (/home/brian) and macOS (/Users/brian).

  # This is the home-manager equivalent of system.stateVersion — set it
  # once at install time and never change it.
  home.stateVersion = "25.11";

  # Let home-manager manage itself.
  programs.home-manager.enable = true;

  # ---------------------------------------------------------------------------
  # Packages available in your user environment
  # ---------------------------------------------------------------------------

  home.packages = with pkgs; [
    # Shell tools
    ripgrep       # fast grep, used by neovim telescope
    fd            # fast find, used by neovim telescope
    jq            # JSON processing
  ];

  # ---------------------------------------------------------------------------
  # Zsh
  # ---------------------------------------------------------------------------
  #
  # Home-manager's programs.zsh generates a ~/.zshrc from these declarations.
  # It replaces zinit entirely — plugins are installed as Nix packages and
  # sourced automatically. No git cloning on first run, no bootstrap step.

  programs.zsh = {
    enable = true;

    # Replaces zinit light zsh-users/zsh-autosuggestions
    autosuggestion.enable = true;

    # Replaces zinit light zsh-users/zsh-syntax-highlighting
    syntaxHighlighting.enable = true;

    # Replaces `bindkey -v` — sets vi keybindings
    defaultKeymap = "viins";

    # Replaces the HIST* variables and setopt lines
    history = {
      size = 2000;
      save = 2000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

    # Additional plugins that don't have dedicated home-manager options.
    # Replaces zinit light Aloxaf/fzf-tab and zsh-users/zsh-completions.
    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/zsh/plugins/fzf-tab";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];

    # Oh-my-zsh snippets — replaces the zinit snippet OMZP:: lines.
    # Note: archlinux plugin is added in home/linux.nix since it's Linux-only.
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    # Keybindings — replaces the bindkey lines
    initContent = ''
      bindkey '^p' history-search-backward
      bindkey '^n' history-search-forward
      bindkey '^f' autosuggest-accept

      # Completion styling — replaces the zstyle lines
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

      # Enter a nix devshell by type (ruby, cpp, rust, default)
      devshell() {
        local type="''${1:-default}"
        nix develop ~/code/dotfiles#"$type"
      }
      # Tab completion for devshell
      _devshell_completions() {
        local -a shells
        shells=(ruby cpp rust default)
        _describe 'devshell type' shells
      }
      compdef _devshell_completions devshell

      # Function for Homelab deploys
      deploy() {
        nix run nixpkgs#nixos-rebuild -- switch \
          --flake ~/code/homelab-nix#$1 \
          --target-host brian@$1 \
          --build-host brian@$1 \
          --sudo \
          --refresh
      }
    '';

    # Replaces the alias lines
    shellAliases = {
      grep = "grep --color=auto";
      vim = "nvim";
      ls = "ls --color=auto";
    };
  };

  # ---------------------------------------------------------------------------
  # Oh My Posh
  # ---------------------------------------------------------------------------

  programs.oh-my-posh = {
    enable = true;
    # Override with your actual omp.toml. home-manager will place the file
    # and pass its path to oh-my-posh automatically.
    settings = builtins.fromTOML (builtins.readFile ../.config/omp.toml);
  };

  # ---------------------------------------------------------------------------
  # Fzf
  # ---------------------------------------------------------------------------
  #
  # Replaces `eval "$(fzf --zsh)"` — home-manager generates the shell
  # integration automatically.

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ---------------------------------------------------------------------------
  # Neovim
  # ---------------------------------------------------------------------------
  #
  # We install neovim via Nix but let lazy.nvim manage all plugins exactly
  # as it does today. Your kickstart.nvim config is symlinked from a local
  # clone of your repo rather than copied into the Nix store — this means
  # you can edit your neovim config and see changes immediately without
  # running `home-manager switch`.
  #
  # HOW mkOutOfStoreSymlink WORKS:
  # Normally home.file copies files into /nix/store (immutable, read-only).
  # mkOutOfStoreSymlink instead creates a symlink pointing at a live path
  # on your filesystem. Edits to that path take effect immediately.
  # The tradeoff is that the path must exist on the machine — if you point
  # it at a repo that isn't cloned yet, neovim won't have a config.
  #
  # SETUP REQUIRED ON EACH MACHINE:
  # Clone your kickstart.nvim repo to ~/code/kickstart.nvim before running
  # home-manager switch:
  #   git clone https://github.com/bcrescimanno/kickstart.nvim ~/code/kickstart.nvim

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/kickstart.nvim";
  };

  # ---------------------------------------------------------------------------
  # Tmux
  # ---------------------------------------------------------------------------

  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    prefix = "C-Space";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
        vim-tmux-navigator
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "weather time"
            set -g @dracula-refresh-rate 5
            set -g @dracula-show-empty-plugins false
            set -g @dracula-show-location false
            set -g @dracula-weather-hide-errors true
            set -g @dracula-fixed-location "San Jose"
            set -g @dracula-time-format "%l:%M %P"
            set -g @dracula-show-powerline true
            set -g @dracula-show-edge-icons false
            '';
        }
    ];
    extraConfig = ''
      set -g terminal-overrides ',xterm*:smcup@:rmcup@'
      bind C-Space send-prefix
      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Tmux config reloaded"
      set -g pane-base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on
      '';
  };

  # ---------------------------------------------------------------------------
  # direnv
  # ---------------------------------------------------------------------------

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Bin scripts
  # ---------------------------------------------------------------------------

  home.file.".config/bin" = {
    source = ../.config/bin;
    recursive = true;
  };

  # Ensure ~/.config/bin is in PATH — replaces the PATH block in .zshrc
  home.sessionPath = [ "${config.home.homeDirectory}/.config/bin" ];

  home.file.".config/git/hooks/pre-commit" = {
    executable = true;
    text = ''
      #!/bin/sh
      if git rev-parse --show-toplevel 2>/dev/null | xargs -I{} test -f {}/flake.nix; then
        echo "Checking flake..."
        nix flake check --no-build
        if [ $? -ne 0 ]; then
          echo "Flake check failed, aborting commit"
          exit 1
        fi
      fi
    '';
  };

  programs.git = {
    settings = {
      core.hooksPath = "~/.config/git/hooks";
      core.excludesFile = "~/.config/git/ignore";
    };
  };

  home.file.".config/git/ignore".text = ''
    .envrc
    .direnv
  '';
}
