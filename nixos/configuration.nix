# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Add unstable channel
# sudo nix-channel --add https://nixos.org/channels/nixos-21.11 nixos
# sudo nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
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

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Allow perf as user
  boot.kernel.sysctl."kernel.perf_event_paranoid" = -1;
  boot.kernel.sysctl."kernel.kptr_restrict" = 0;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # To check out which network interface to enable checkout cmd 'ifconfig -a'
  # Network interface name might change for examle after GPU replacement
  networking.interfaces.enp7s0.useDHCP = true;

  # Enable root authentication using popup (ex. for gparded)
  security.polkit.enable = true;
  # Audio using pipewire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Add printer by web interface: http://localhost:631/printers  ; then Add printer, for Brother HL-L2350DW use HL-L2360D model from list
  services.printing.drivers = [
    pkgs.brlaser # For brother printers
  ];
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  # Required for icons in dolphin; https://github.com/NixOS/nixpkgs/issues/25762
  # Then requires configuration of theme in qt5ct program
  programs.qt5ct.enable = true;

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
  };


  # Configure keymap in X11
  services.xserver.layout = "pl";
  services.xserver.xkbVariant = "colemak";

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
    plugins = [ "git" "sudo" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sway" "storage" "video"];
    shell = pkgs.zsh; # Make zsh default shell
  };

  # maybe useful for authentication, might be used by vs-code
  # services.gnome.gnome-keyring.enable = true;

  # Auto log in
  services.getty.autologinUser = "pc";
  nixpkgs.config.allowUnfree = true;

  environment.enableDebugInfo = true;
  environment.pathsToLink = [ "/libexec" ]; # Make polkit-gnome-authentication-agent-1 visible under /run/current-system/sw
  environment.systemPackages = with pkgs; [
    mako # Notifications
    jq # Command line utility to parse and get values from json output
    alacritty # Terminal
    usbutils # lsusb
    # Basic programs
    pinta # Image draw/edit
    chromium # Sometimes has something which Firefox doesn't have, better printing support
    fd # Better find
    firefox # Main browser
    fzf # Fuzzy finder
    glib # For trash support
    gnome.gnome-terminal # May help with drag and drop while uncompressing data

    # Themes
    font-awesome # For icons in i3status-rust
    gnome3.gnome-system-monitor # Task manager
    dracula-theme # Additional themes, maybe will fix lack of icons in nwg-launchers
    gnome3.adwaita-icon-theme # Additional themes, maybe will fix lack of icons in nwg-launchers
    hicolor-icon-theme  # Additional themes, maybe will fix lack of icons in nwg-launchers
    tango-icon-theme # For icons in thunar

    libreoffice # Documents editing
    mesa-demos # glxinfo
    nwg-launchers # Launcher of applications with apps icons
    pulseaudio pavucontrol # For audio inputs/outputs
    i3status-rust # Bar
    wally-cli # To install moonlander keyboard firmware
    vim
    vscode
    wget
    slurp grim # Wayland screenshots
    vlc # Videos
    appimage-run
    # gimp
    pcmanfm
    # dolphin
    termite
    qjackctl # Advanced audion input/output control
    gthumb
    kitty
    xdg-utils # Default application settings, xdg-mime default nautilus.desktop inode/directory
    polkit_gnome
    # Sway
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    clipman
    wofi
    # Filesystem
    # btrfs-progs
    gparted # This works: sudo -EH gparted
    ntfs3g
    # texlive.combined.scheme-full # Quite heavy, use when needed
    # texstudio
    # Games
    # teamspeak_client
    # unstable.discord
    # wineWowPackages.staging
    # unstable.wine64Packages.stagingFull
    # unstable.winePackages.stagingFull
    # unstable.winetricks
    # (winetricks.override { wine = wineWowPackages.staging; })
    # vulkan-tools
    # lutris
    # sc-controller
    # NixOS development
    # mm_hello # My test package :)
    # nix-prefetch-github # For getting sha256 for github packages
    # Programming
    # unstable.neovim
    # unstable.neovim-qt
    # unstable.tracy
    gdb
    gitFull
    hotspot
    linuxPackages.perf
    perf-tools
    pkg-config
    python38
    python38Packages.pip
    # Games
    # lutris
    # openmw
    # Game development
    binutils-unwrapped
    blender
    gcc9Stdenv
    # gdc
    # ldc
    # ninja
    # cjson
    # unstable.mesoin
    # Bubel engine
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    # Support for some archive formats
    afio
    cpio
    fsarchiver
    lzma
    gnutar
    innoextract
    p7zip
    rpmextract
    runzip
    s-tar
    sharutils
    unar
    unp
    unrar
    unzip
    xarchive
    xarchiver
    zip
    zpaq
  ];

  # Automount extensions
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;


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

