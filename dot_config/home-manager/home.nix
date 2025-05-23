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
    ast-grep
    bat
    bat-extras.prettybat
    bat-extras.batman
    bat-extras.batgrep
    # TODO: Not sure if I can install all bat-extras binaries like below, or if I have to specify
    # them 1 by 1
    # bat-extras
    beets
    bemenu
    brightnessctl
    cinny-desktop
    chezmoi
    comby
    cmus
    cmusfm
    dbeaver-bin
    delta
    deno
    docker
    dust
    # unfree
    # drawio
    electrum
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
    glab
    gparted
    ueberzugpp
    hurl
    # usbimager
    imagemagick
    josm
    openvpn
    # Create an entry for this
    # keep-presence
    kiwix
    # wait to install until a later version comes out without the security vulnerabilities that are inherent in this version
    # jitsi-meet
    jq
    jless
    nodePackages.jsonlint
    gcc
    obs-studio
    localstack
    librewolf
    lsd
    lua51Packages.lua
    luajitPackages.luarocks
    gnumake42
    maven
    mergiraf
    mullvad
    neovim
    nix-index
    nodejs_22
    nmap
    pavucontrol
    plocate
    python311
    prettierd
    # protonmail-bridge
    protonmail-desktop
    restic
    resticprofile
    ripgrep
    rustup
    # TODO: Create package for reformat-gherkin
    ruby
    starship
    shellcheck
    python313Packages.sqlfmt
    shfmt
    stylua
    strawberry
    speedtest-cli
    standardnotes
    signal-desktop
    swayr
    swayrbar
    # tidal_dl_ng
    tmux
    tmuxinator
    tree-sitter
    universal-ctags
    unzip
    vim
    yamlfmt
    # screenshot functionality (or slurp)
    # grim
    # notification system
    # mako
    # TODO: Make an issue with this wofi nixpkg - crashes if 'wofi' not installed
    wofi
    wget
    wl-clipboard
    wireguard-tools
    yazi
    zig
    zoxide
    zulu17
    zulip
    zulip-term
    nerd-fonts.jetbrains-mono
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # LSPs
    # TODO: Should I not let mason handle all LSPs? Probably should remove these
    # TODO: 'clangd'
    # TODO: cssmodules_ls
    # TODO: cucumber_language_server
    # TODO: prismals
    # TODO: smithy_ls
    # TODO: sqlls
    basedpyright
    rubyPackages_3_4.standard
    docker-compose-language-service
    # HTML/CSS/JSON/ESLint lang servers
    vscode-langservers-extracted
    vue-language-server
    ruff
    nil
    phpactor
    tailwindcss-language-server
    terraform-ls
    typos-lsp
    bash-language-server
    docker-ls
    lua-language-server
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
