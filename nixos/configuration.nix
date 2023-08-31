# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Add unstable channel
# sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
# sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
# sudo nix-channel --update

# Set current generation as default to boot
# /run/current-system/bin/switch-to-configuration boot

# To upgrade:
# sudo nix-channel --update
# sudo nix-channel --update nixos-unstable
# sudo nixos-rebuild switch --upgrade-all
# sudo nixos-rebuild switch --rollback

# Clean up
# sudo nix-env -p /nix/var/nix/profiles/system --list-generations
# nix-collect-garbage -d
# sudo nix-collect-garbage -d # Careful! removes old generation

# List packages installed in system profile. To search, run:
# nix search wget


{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand"; # From 47 FPS to 140 FPS in CS:GO
  };

  # Allow non free (steam, itp)
  nixpkgs.config.allowUnfree = true;
  # Get debug information for some programs
  environment.enableDebugInfo = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelModules = [ "kvm-amd" "k10temp" "nct6775" "zenpower" ];

  # Allow perf as user
  boot.kernel.sysctl."kernel.perf_event_paranoid" = -1;
  boot.kernel.sysctl."kernel.kptr_restrict" = 0;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  # Docker
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pc = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # For sudo
      "sway"
      "storage"
      "video"
      "networkmanager" # So user can change network settings
      "docker"
    ];
    shell = pkgs.zsh; # Make zsh default shell
  };

  # Auto log in
  services.getty.autologinUser = "pc";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  # services.blueman.enable = true; # Made main screen look bad

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Add printer by web interface: http://localhost:631/printers  ; then Add printer, for Brother HL-L2350DW use HL-L2360D model from list
  # If printer not shown after 'Add printer', try 'sudo systemctl restart cups.service' or 'lpinfo -l -v' or 'reconnect USB'
  # For adding printer connected to localnetwork:
  # Find pinter ip address by checking it int router (http://192.168.1.1/)
  # Then under http://localhost:631/printers add "LPD/LPR Host or Printer" url ip like: socket://<PRINTER IT>
  services.printing.drivers = [
    pkgs.brlaser # For brother printers
  ];


  # Configure keymap in X11
  services.xserver.layout = "pl";
  services.xserver.xkbVariant = "colemak";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.utf8";
    LC_IDENTIFICATION = "pl_PL.utf8";
    LC_MEASUREMENT = "pl_PL.utf8";
    LC_MONETARY = "pl_PL.utf8";
    LC_NAME = "pl_PL.utf8";
    LC_NUMERIC = "pl_PL.utf8";
    LC_PAPER = "pl_PL.utf8";
    LC_TELEPHONE = "pl_PL.utf8";
    LC_TIME = "pl_PL.utf8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Automount extensions
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;
  # If fails try to mount using: udisksctl mount -p /dev/sdX9

  # Enable root authentication using popup (ex. for gparded)
  security.polkit.enable = true;
  environment.pathsToLink = [ "/libexec" ]; # Make polkit-gnome-authentication-agent-1 visible under /run/current-system/sw

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    # extraPackages = with pkgs; [
    #   swaylock
    #   swayidle
      # wl-clipboard
      # clipman
      # wofi
    #   mako # notification daemon
    #   alacritty # Alacritty is the default terminal in the config
    #   dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    # ];
    # extraSessionCommands = ''
    #   export SDL_VIDEODRIVER=wayland # Breaks games on steam (certainly dota2 and CS:GO)
    #   export QT_QPA_PLATFORM=wayland
    #   export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    #   export _JAVA_AWT_WM_NONREPARENTING=1
    #   export MOZ_ENABLE_WAYLAND=1 # Firefox freezes when using wayland (2022.11)
    # '';
  };


  # maybe useful for authentication, might be used by vs-code
  # services.gnome.gnome-keyring.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Games
  programs.steam.enable = true;
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    driSupport32Bit = true;
  };
  # Enable zsh
  programs.zsh.enable = true;
  programs.file-roller.enable = true;

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    theme = "robbyrussell";
    plugins = [
      "git"
      "sudo" # add 'sudo' after pressing esc+esc
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      # # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;
      # # Required for containers under podman-compose to be able to talk to each other.
      # defaultNetwork.dnsname.enable = true;
    };
  };


  environment.systemPackages = with pkgs; [

    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        streetsidesoftware.code-spell-checker
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.bungcip.better-toml
        # vscode-extensions.ms-vscode.cpptools # Disable for now as it triggered some errors in vscode
        vscode-extensions.shardulm94.trailing-spaces
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "code-d";
          publisher = "webfreak";
          version = "0.23.2";
          sha256 = "bff0dc938804f644647c858f0245263ea7b0c935552ab060023a4db8244e0a51";
        }
        {
          name = "vscode-test-explorer";
          publisher = "hbenl";
          version = "2.21.1";
          sha256 = "7c7c9e3ddf1f60fb7bccf1c11a256677c7d1c7e20cdff712042ca223f0b45408";
        }
        {
          name = "test-adapter-converter";
          publisher = "ms-vscode";
          version = "0.1.6";
          sha256 = "502f2d51ef89277afc9dbf52b0f96f557c3be16ef92568cc89f937f490a5445e";
        }
        {
          name = "meson";
          publisher = "asabil";
          version = "1.3.0";
          sha256 = "40ca77744171e8cbb9a60ce4972956e9bfee8186ed6d3feacfc21e7aeccf65e0";
        }
        {
          name = "shader";
          publisher = "slevesque";
          version = "1.1.5";
          sha256 = "3dfdfb15e40c365bfbe1fecb333f7e08ab1c17a5234d9ed9a5c69914ab57d993";
        }
      ];
    })
    # Main Programs
    alacritty # Terminal
    blender # 3d model editing
    chromium # Sometimes has something which Firefox doesn't have, better printing support
    firefox # Main browser
    gparted # This works: sudo -EH gparted
    btrfs-progs # Tools for btrfs file system
    gthumb # Images viewer
    hotspot # Program to analyze memory usage/leaks of given program
    libreoffice # Documents editing
    mpv # Player for audio, video
    pcmanfm # File manager
    pinta # Image draw/edit
    vlc # Player for audio, video
    vscode # vscode
    teamspeak_client # Talking with people
    # dolphin # File manager
    gimp # Images editing
    imagemagick # Command line image utilities
    # qbittorrent
    # lutris
    rust-analyzer # LSP for rust
    helix
    lazygit
    # kitty # Terminal
    # termite # Terminal

    # Hardware monitoring/configuration tools
    jmtpfs mtpfs # Access phone data

    hardinfo # GUI for some hw information
    lm_sensors # For temperature information
    mesa-demos # glxinfo
    parted # For partitioning
    pulseaudio pavucontrol # For audio inputs/outputs
    qjackctl # Advanced audion input/output control
    easyeffects # pipewire audio input/output control and effects
    radeontop # Display AMD GPU usage statistics/bottlenecks
    usbutils # lsusb
    vulkan-tools # vkcube
    wally-cli # To install moonlander keyboard firmware
    xdg-utils # Default application settings, xdg-mime default nautilus.desktop inode/directory

    # Basic cmd tools
    appimage-run # For runnning appimage programs
    fd # Better find
    fzf # Fuzzy finder
    jq # Command line utility to parse and get values from json output
    vim # vim
    wget # Downloading files using command line

    # Sway/Wayland enviroment
    clipman # Clipboard manager for wayland
    i3status-rust # Bar
    mako # Notifications
    nwg-launchers # Launcher of applications with apps icons
    slurp grim # Wayland screenshots
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    wofi # Wayland native menu

    # Basic system libraries
    glib # For trash support
    polkit_gnome # dbus session providing functionality for authenticate popups?

    # Support for some archive formats
    afio cpio fsarchiver lzma gnutar innoextract p7zip rpmextract runzip
    s-tar sharutils unar unp unrar unzip xarchive xarchiver zip zpaq

    # Themes
    dracula-theme # Additional themes, maybe will fix lack of icons in nwg-launchers
    font-awesome # For icons in i3status-rust
    gnome3.adwaita-icon-theme # Additional themes, maybe will fix lack of icons in nwg-launchers
    gnome3.gnome-system-monitor # Task manager
    hicolor-icon-theme  # Additional themes, maybe will fix lack of icons in nwg-launchers
    tango-icon-theme # For icons in thunar

    # Programming
    binutils-unwrapped
    gcc9Stdenv
    gdb # Debugging
    gitFull # git with git-gui
    linuxPackages.perf perf-tools # perf
    pkg-config
    python39
    python39Packages.pillow

    # 3d printing
    openscad
    cura

    # Games
    lutris

    # NixOS development
    # nix-prefetch-github # For getting sha256 for github packages

    # Tex
    # texlive.combined.scheme-full # Quite heavy, use when needed
    # texstudio

    # Additional hardware support
    ntfs3g # ntfs driver
    # btrfs-progs
    # sc-controller # Steam controller
  ];

  # Available fonts
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      font-awesome
      inconsolata
      source-code-pro
      source-sans-pro
      source-serif-pro
      terminus_font
    ];
  };


  system.stateVersion = "22.05";

}

