{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "drew";
  home.homeDirectory = "/home/drew";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # SERVICES CONFIGURATION
  # Automatically start on boot
  services.gpg-agent = {
	enable = true;
	defaultCacheTtl = 1800;
	enableSshSupport = true;
  };
  services.gnome-keyring.enable = true;
  # desktopManager+windowManager
  # wayland.windowManager.sway.enable = true;

  # PACKAGES CONFIGURATION
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    awscli2
    bat
    bat-extras.prettybat
    bat-extras.batman
    bat-extras.batgrep
    # TODO: Not sure if I can install all bat-extras binaries like below, or if I have to specify
    # them 1 by 1
    # bat-extras
    beets
    brightnessctl
    chezmoi
    cmus
    cmusfm
    delta
    deno
    docker
    dust
    fd
    feh
    foliate
    fish
    fzf
    gh
    git
    git-credential-oauth
    go
    google-cloud-sdk
    gparted
    # usbimager
    # gnome-disk-utility
    imagemagick
    # iterm2
    openvpn
    # Create an entry for this
    # keep-presence
    kiwix
    jq
    jless
    gcc
    librewolf
    lsd
    lua51Packages.lua
    luajitPackages.luarocks
    gnumake42
    mergiraf
    # mise
    # TODO: Figure out how to get mullvad to work - seems to be broken on NixOS
    # mullvad
    neovim
    nix-index
    nodejs_22
    nmap
    pavucontrol
    plocate
    python311
    # rcmd
    restic
    resticprofile
    ripgrep
    rustup
    rofi
    ruby
    starship
    strawberry
    speedtest-cli
    # standardnotes
    # tidal_dl_ng
    tmux
    tmuxinator
    tree-sitter
    universal-ctags
    unzip
    # TODO: Unfree, need to allow this
    # veracrypt
    vim
    # screenshot functionality (or slurp)
    # grim
    # notification system
    # mako
    wget
    wl-clipboard
    wireguard-tools
    yazi
    zig
    zoxide
    zulu17
    # zoom
    # TODO: wl-clipboard, or xclip? Need to confirm if I'm using Wayland by default first.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # LSPs
    nodePackages_latest.vscode-json-languageserver
    tailwindcss-language-server
    terraform-ls
    typos-lsp
    bash-language-server
    docker-ls
    lua51Packages.lua-lsp
    marksman
    yaml-language-server
    tflint
    emmet-language-server
    python311Packages.python-lsp-server
    typescript-language-server
    vim-language-server
    clojure-lsp
  ];

  # DOTFILES
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    #".gradle/gradle.properties".text = ''
    #  org.gradle.console=verbose
    #  org.gradle.daemon.idletimeout=3600000
    #'';
    # TODO: Figure out why adding this causes home manager to complain about conflicts, even when this file doesn't exist
    # ".gnupg/gpg.conf" = {
    #     source = ~/.local/share/chezmoi/private_dot_gnupg;
    #     recursive = true;
    # };
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
  #  /etc/profiles/per-user/drew/etc/profile.d/hm-session-vars.sh
  #
  # ENV VARS
  home.sessionVariables = {
	  # EDITOR = "nvim";
  };

  # PROGRAMS
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  # Defaults to GnuPG
  programs.gpg = {
	enable = true;
  };

  programs.git-credential-oauth.enable = true;
}
