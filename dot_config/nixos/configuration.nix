# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "America/Chicago";
  # For automatic timezone adjustment: https://discourse.nixos.org/t/timezones-how-to-setup-on-a-laptop/33853/7
  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # USB drives
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # https://nixos.wiki/wiki/Yubikey
  services.pcscd.enable = true;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb = {
  #   layout = "us";
  #   variant = "";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  security.rtkit.enable = true;
  services.avahi.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    raopOpenFirewall = true;
    extraConfig.pipewire = {
      "10-airplay" = {
        "context.modules" = [
          {
            name = "libpipewire-module-raop-discover";
          }
        ];
      };
    };
  };

  # https://nixos.org/manual/nixos/stable/#trezor
  services.trezord.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.drew = {
    isNormalUser = true;
    description = "Drew Daniels";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
    # passwordFile = config.age.secrets.secrets.path;
  };

  # Virtualisation
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  virtualisation.virtualbox.host.enable = true;

  # Enable sway
  programs.sway.enable = true;

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = ["drew"];
  };

  # Allow unfree packagesA
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # inputs.helix.packages."${pkgs.system}".helix
  ];

  # https://blog.nobbz.dev/blog/2023-02-27-nixos-flakes-command-not-found
  # Adjust the value for the nixexpr.tar.xz if necessary
  environment.etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # EXPERIMENTAL SETTINGS
  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.udev.packages = [pkgs.yubikey-personalization];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:
  # TODO: Need to do some hackery to get this to work: https://discourse.nixos.org/t/thinkpad-x270-fingerprint-reader-support/24177
  # Have the same sensor model as OP
  # services.fprintd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  services.mullvad-vpn.enable = true;

  # VPN
  # https://alberand.com/nixos-wireguard-vpn.html
  networking.firewall.allowedUDPPorts = [51820];

  # To start:
  # sudo systemctl stop wg-quick-wg0

  # To stop:
  # sudo systemctl start wg-quick-wg0

  # Debugging Note: If I notice that the wg0 connection no longer exists for some reason,
  # power off laptop (don't restart), and then manually power back on. After logging back in, rebuild and see if the connection reappears.
  # Debugging Note 2: May just need to ensure that ~/.env and ~/.env.fish have necessary HOME_DDNS_NAME secret. If 1Password Desktop isn't started when the run_once_before_01-install-secrets.sh.tmpl script runs, the `op` commands will silently fail. And this step will need to be re-run manually
  # Debugging Note 3: If the wireguard config needs to get re-generated, because of an unset value (like Endpoint), change the persistentKeepalive value to something different so it gets rebuilt with the right value
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.0.0.5/24"];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/wg0-private-key";
      # See ./wg-peers.nix
      # peers = [];
      autostart = false;
      dns = ["64.6.64.6" "10.0.0.1"];
    };
  };

  system.autoUpgrade = {
    enable = true;
    dates = "02:00";
  };

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
