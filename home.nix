{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mark";
  home.homeDirectory = "/Users/mark";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.sessionPath = [
    # TODO: "$HOME/.local/bin"
  ];

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.lazygit
    pkgs.helix
    pkgs.neovim
    pkgs.python3
    pkgs.zellij
    pkgs.rustup
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mark/etc/profile.d/hm-session-vars.sh
  #

  home.shellAliases = {
      v = "nvim";
      vim = "nvim";
      lg = "lazygit";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

 programs.git = {
   enable = true;
   userName = "Mark Keller";
   userEmail = "8452750+keller00@users.noreply.github.com";
   ignores = [
      ".activate.sh"
      ".deactivate.sh"
      ".idea"
      ".vscode"
      ".tox"
      ".mypy_cache"
   ];
   includes = [
      {path = "~/.gitconfig.local";}
   ];
   aliases = {
     st = "status";
     d = "diff";
   };
   extraConfig = {
       core = {
           whitespace = "space-before-tab,trailing-space";
           autocrlf = "input";
       init = {
           defaultBranch = "main";
           templateDir = "~/.git-template";
       };
       pull = {
           rebase = true;
       };
       rebase = {
           autostash = true;
       };
   };
 }; 
};

  programs.zsh = {
    enable=true;
    enableCompletion = true;
    initExtraBeforeCompInit = ''
      zstyle ':completion:*' completer _complete _ignored _correct
      zstyle ':completion:*' max-errors 3
      CASE_SENSITIVE="true";
    '';
    initExtra = ''
      setopt nomatch notify
      unsetopt autocd beep extendedglob
      # TOOD: doesn't seem to work HIST_STAMPS="yyyy-mm-dd"     # Add timstamps to history entries.
      setopt INC_APPEND_HISTORY    # Write to the history file immediately, not when the shell exits.
      setopt HIST_NO_STORE         # Don't store history commands
      setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from each command line being added to the history.

      # Make virtualenvs reproducible
      export VIRTUALENV_PIP="embed"
      export VIRTUALENV_SETUPTOOLS="embed"
      export VIRTUALENV_WHEEL="embed"
      export VIRTUALENV_NO_PERIODIC_UPDATE="True"
      
      # TODO: eval "$(aactivator init)"
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^R" history-incremental-search-backward
      bindkey "\e[3~" delete-char
      # TODO
      if [[ -f "$HOME/.cargo/env" ]]; then
        . "$HOME/.cargo/env"
      fi

      . $HOME/.config/zsh/themes/oxide/oxide.zsh-theme
      . $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
      . $HOME/.config/zsh/plugins/zsh-window-title/zsh-window-title.plugin.zsh
    '';
    history = {
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
      ignorePatterns = [
        "ls *"
        "cd *"
        "pwd *"
        "exit *"
      ];
    };
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file = {
    ".config/zsh" = {
      source = ./zsh;
      recursive = true;
    };
  };
}
