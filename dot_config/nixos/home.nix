{
  config,
  pkgs,
  ...
}:
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

  services.mpris-proxy.enable = true;
  # services.gnome-keyring.enable = true;
  # desktopManager+windowManager
  # wayland.windowManager.sway.enable = true;
  nixpkgs.config.allowUnfree = true;

  # PACKAGES CONFIGURATION
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # TODO: Re-enable once either of these are merged:
    # https://github.com/NixOS/nixpkgs/pull/328890
    # https://github.com/NixOS/nixpkgs/pull/423931
    # Power management
    # https://nixos.wiki/wiki/Laptop
    # TODO: Figure out how to share configuration across all linux laptops, rather than configuring this in confiugration.nix just on NixOS
    # auto-cpufreq
    # espanso-wayland
    # Nix utils
    # For nix-prefetch-git and others
    nix-prefetch-scripts
    # CLI
    hexyl
    # Android
    apksigner
    # TODO: May want to move nix-index into configuration.nix instead - won't be necessary outside of NixOS
    # NixOS
    nix-index
    # Nickel programming language
    # nickel
    # nls
    # Prompt
    starship
    # Shells
    fish
    # Gemini Protocol
    # amfora
    # lagrange
    # Web
    google-chrome
    firefox
    librewolf
    lynx
    tor-browser
    nyxt
    # shadowsocks-rust
    qutebrowser
    # TODO: Only installing this to test this qutebrowser userscript: https://github.com/qutebrowser/qutebrowser/blob/main/misc/userscripts/qute-1pass
    wofi
    # Terminal Emulators
    alacritty
    # foot
    # Cloud
    # TODO: Figure out why this package won't build
    # awscli2
    backblaze-b2
    fh
    gh
    glab
    forgejo
    forgejo-cli
    gitlab-ci-ls
    # google-cloud-sdk
    # localstack
    # pulumi
    # grep
    ast-grep
    # comby
    # Launchers
    bemenu
    # Camera
    cheese
    # Screenshots: Ex.) grim -g "$(slurp)" - | satty -f - -o ~/Pictures/Screenshots/screenshot.png
    grim
    slurp
    satty
    # Matrix
    # element-desktop
    # NOTE: many libsoup 2 vulnerabilities - this package needs to be updated to use libsoup 3
    # cinny-desktop
    # Chat
    # TODO: Reinstall once package hash fixed: https://github.com/NixOS/nixpkgs/issues/426923
    # simplex-chat-desktop
    signal-desktop
    # TODO: Re-enable this at some point and figure out why build fails
    # zulip
    # zulip-term
    # jami
    # Chart
    d2
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
    qt6Packages.qt6ct
    streamrip
    rclone
    # video
    mpv
    obs-studio
    # TODO: Create an issue in nixpkgs - this package doesn't appear to work (maybe just a wayland issue)
    # kooha
    # clipboard
    cliphist
    wl-clipboard
    # databases
    postgrest
    # database clients
    dbeaver-bin
    # git
    chezmoi
    delta
    difftastic
    gitFull
    git-credential-oauth
    gitleaks
    mergiraf
    # filesystem
    pdfgrep
    lnav
    bat
    bat-extras.prettybat
    bat-extras.batman
    bat-extras.batgrep
    dust
    exfatprogs
    fd
    fzf
    jc
    hdparm
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
    nvme-cli
    # diagrams
    # drawio
    # btc
    # NOTE: CVEs related to Python3 version required in these electrum packages
    # electrum
    # electrum-ltc
    trezor-suite
    # security
    yubioath-flutter
    openssl
    sherlock
    # TODO: Create an issue in nixpkgs about this package being broken.
    # This package was mentioned in this issue, but for a different architecture: https://github.com/NixOS/nixpkgs/issues/185049#issuecomment-1334457220
    # maigret
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
    # PDF
    resvg
    poppler
    # If wanting to use the poppler backend
    # zathura
    # If wanting to use muPDF backend
    # https://discourse.nixos.org/t/how-to-customize-zathura-here/64188/3
    (pkgs.zathura.override { plugins = with pkgs.zathuraPkgs; [ zathura_pdf_mupdf ]; })
    sioyek
    libreoffice-qt6-fresh
    # Geo
    josm
    just
    # VPN
    openvpn
    wireguard-tools
    # TODO: Figure out how to configure mullvad such that lockdown mode is always disabled. Seems like this somewhat randomly gets re-enabled sometimes
    mullvad
    # JSON
    jq
    jqp
    jless
    nodePackages.jsonlint
    # NOTE: Not sure if 'gcc' needs to be installed at a user-level
    gcc
    # lua51Packages.tree-sitter-norg
    lua5_1
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
    thunderbird
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
    # NOTE: Need to install nodejs to compile latex parser - but can uninstall after compilation
    # nodejs_22
    neovim
    vim
    universal-ctags
    nodePackages.live-server
    tree-sitter
    texlab
    texliveFull
    typst
    # NOTE: Included with tinymist: https://github.com/Myriad-Dreamin/tinymist/blob/main/editors/neovim/README.md#formatting
    # typstyle
    tinymist
    # NOTE: No jsonresume-theme-* packages are uploaded to nixpkgs, so can't really use this, since it doesn't come with any default theme
    # resumed
    rendercv
    # NOTE: Required dependency for chomosuke/typst-preview.nvim
    websocat
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
    # standardnotes
    # nb
    # sshx
    swayr
    swayrbar
    sway-audio-idle-inhibit
    waybar
    # tidal-hifi
    ostui
    # multiplexers
    tmux
    tmuxinator
    # qr
    qrencode
    # zulu17
    # Fonts
    nerd-fonts.jetbrains-mono
    # Formatters & LSPs
    # TODO: Should I not let mason handle all LSPs? Probably should remove these
    # TODO: cssmodules_ls
    # TODO: cucumber_language_server
    # TODO: prismals
    # TODO: smithy_ls
    # TODO: Need to do more research on seeing whether or not it makes sense to just use nil_ls, nixd, or both
    # nixd
    # TODO: Create package for reformat-gherkin
    tex-fmt
    flutter
    gopls
    # TODO: Figure out why I have hyprls 0.6.0 installed, but the latest available on nixos-unstable is 0.7.0
    # 0.7.0 should fix the below issue
    # https://github.com/hyprland-community/hyprls/issues/19
    golines
    jdt-language-server
    yamlfmt
    prettierd
    nixfmt-rfc-style
    eslint_d
    cljfmt
    shfmt
    stylua
    shellcheck
    basedpyright
    deno
    rubyPackages_3_4.standard
    rubyPackages_3_4.htmlbeautifier
    rust-analyzer
    docker-compose-language-service
    # virtualization
    dive
    podman-tui
    # docker-compose
    podman-compose
    # HTML/CSS/JSON/ESLint lang servers
    vacuum-go
    vscode-langservers-extracted
    ruff
    nil
    nixpacks
    phpactor
    tailwindcss-language-server
    terraform-ls
    typos-lsp
    bash-language-server
    dockerfile-language-server
    lua-language-server
    lemminx
    marksman
    yaml-language-server
    taplo
    tflint
    emmet-language-server
    # Library that wraps tsserver such that it supports the LSP protocol - alternatives are vtsls or typescript-tools.nvim
    # typescript-tools.nvim does not currently support vue integration however, so ts_ls or vtsls are the only available options at the moment
    typescript-language-server
    vue-language-server
    svelte-language-server
    # TODO: Figure out which one of these Python packages has a dependency issue causing a similar error to this:
    # https://github.com/NixOS/nixpkgs/issues/417098
    # python313Packages.sqlfmt
    # python311Packages.python-lsp-server
    python313Packages.pgcli
    vim-language-server
    clojure-lsp
    sqls
    # hyprls
    # Utils
    brightnessctl
    pciutils
    # Music
    mixxx
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
