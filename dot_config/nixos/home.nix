{
  config,
  pkgs,
  ...
}: {
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

  services.mpris-proxy.enable = true;
  # services.gnome-keyring.enable = true;
  # desktopManager+windowManager
  # wayland.windowManager.sway.enable = true;
  nixpkgs.config.allowUnfree = true;

  # PACKAGES CONFIGURATION
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # Android
    apksigner
    # TODO: May want to move nix-index into configuration.nix instead - won't be necessary outside of NixOS
    # NixOS
    nix-index
    nickel
    nls
    # Prompts
    starship
    # Shells
    fish
    # Gemini Protocol
    amfora
    lagrange
    # Web
    firefox
    librewolf
    cromite
    lynx
    tor-browser
    nyxt
    shadowsocks-rust
    qutebrowser
    # TODO: Only installing this to test this qutebrowser userscript: https://github.com/qutebrowser/qutebrowser/blob/main/misc/userscripts/qute-1pass
    wofi
    # Terminal Emulators
    alacritty
    foot
    # Cloud
    awscli2
    fh
    gh
    glab
    google-cloud-sdk
    localstack
    pulumi
    # grep
    ast-grep
    comby
    # Launchers
    bemenu
    # Camera
    cheese
    # Screenshots: Ex.) grim -g "$(slurp)" - | satty -f - -o ~/Pictures/Screenshots/screenshot.png
    grim
    slurp
    satty
    # Matrix
    element-desktop
    cinny-desktop
    # Chat
    simplex-chat-desktop
    signal-desktop
    zulip
    zulip-term
    jami
    # IRC
    halloy
    weechat
    weechatScripts.autosort
    znc
    # WIKI
    kiwix
    # Music
    cmus
    cmusfm
    strawberry
    beets
    pavucontrol
    mpd
    ncmpcpp
    qt6ct
    streamrip
    # TODO: Create package
    # tidal-dl-ng
    # video
    mpv
    obs-studio
    # clipboard
    cliphist
    wl-clipboard
    dbeaver-bin
    # git
    chezmoi
    delta
    git
    git-credential-oauth
    git-secrets
    mergiraf
    # filesystem
    bat
    bat-extras.prettybat
    bat-extras.batman
    bat-extras.batgrep
    dust
    fd
    fzf
    ripgrep
    plocate
    file
    lsof
    yazi
    zoxide
    usbutils
    usbimager
    gparted
    lsd
    pandoc
    unzip
    # diagrams
    drawio
    # btc
    electrum
    electrum-ltc
    trezor-suite
    # security
    yubioath-flutter
    openssl
    sherlock
    maigret
    magic-wormhole
    sops
    passage
    keepassxc
    pwgen
    libsecret
    rusty-diceware
    # books
    foliate
    hunspell
    # http
    hurl
    wget
    # notifications
    mako
    # for testing notifications, with 'notify-send "Test" "this is a test"'
    libnotify
    # images
    imagemagick
    ueberzugpp
    feh
    swaybg
    waypaper
    swww
    # Office
    zathura
    libreoffice-qt6-fresh
    # Geo
    josm
    just
    # VPN
    openvpn
    wireguard-tools
    mullvad
    # JSON
    jq
    jless
    nodePackages.jsonlint
    gcc
    lua51Packages.tree-sitter-norg
    luajitPackages.luarocks
    gnumake42
    # VOIP
    mumble
    # Calculator
    qalculate-qt
    libqalculate
    # Email
    protonmail-bridge
    protonmail-desktop
    neomutt
    isync
    notmuch
    muchsync
    urlscan
    msmtp
    lieer
    # Contacts
    abook
    # Editors
    neovim
    vim
    universal-ctags
    nodePackages.live-server
    tree-sitter
    # RSS
    newsraft
    # Networking
    nmap
    tor
    torsocks
    nyx
    speedtest-cli
    # Backups
    restic
    resticprofile
    # Notes
    obsidian
    standardnotes
    nb
    # sshx
    swayr
    swayrbar
    sway-audio-idle-inhibit
    waybar
    # TODO: Create package
    # tidal_dl_ng
    # NOTE: tidal-hifi seems broken - freezes
    # tidal-hifi
    # multiplexers
    tmux
    tmuxinator
    # TODO: Make an issue with this wofi nixpkg - crashes if 'wofi' not installed
    # zulu17

    # Fonts
    nerd-fonts.jetbrains-mono
    # Formatters & LSPs
    # TODO: Should I not let mason handle all LSPs? Probably should remove these
    # TODO: 'clangd'
    # TODO: cssmodules_ls
    # TODO: cucumber_language_server
    # TODO: prismals
    # TODO: smithy_ls
    # TODO: Need to do more research on seeing whether or not it makes sense to just use nil_ls, nixd, or both
    # nixd
    # TODO: Create package for reformat-gherkin
    yamlfmt
    prettierd
    alejandra
    eslint_d
    cljfmt
    python313Packages.sqlfmt
    shfmt
    stylua
    shellcheck
    basedpyright
    deno
    rubyPackages_3_4.standard
    rubyPackages_3_4.htmlbeautifier
    docker-compose-language-service
    # HTML/CSS/JSON/ESLint lang servers
    vscode-langservers-extracted
    vue-language-server
    ruff
    nil
    nixpacks
    phpactor
    tailwindcss-language-server
    terraform-ls
    typos-lsp
    bash-language-server
    dockerfile-language-server-nodejs
    lua-language-server
    marksman
    yaml-language-server
    taplo
    tflint
    emmet-language-server
    python311Packages.python-lsp-server
    vim-language-server
    clojure-lsp
    sqls
    hyprls
    # Utils
    brightnessctl
    pciutils
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
  programs.home-manager = {
    enable = true;
  };
  # Defaults to GnuPG
  programs.gpg = {
    enable = true;
  };

  # TODO: Figure out how to source nix-direnv logic, without letting home-manager clobber my ~/.bashrc
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    # bash.enable = true;
  };

  programs.git-credential-oauth.enable = true;

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
