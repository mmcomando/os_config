# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # My additional packages
  nixpkgs.overlays = import /home/pc/os_config/nixos/overlay;

  # Use the GRUB 2 boot loader.

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Linux kernel options
  boot.kernelPackages = pkgs.linuxPackages_5_10; # On default kernel my 3440x1440 monitor doesn't work
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = -1; # For perf
  };
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  
  
  # Enable CUPS to print documents.
  # Doesn't work now :/
  services.printing.enable = true;
  services.printing.drivers = [ 
    # pkgs.mm_brlaser # For brother printers
    # pkgs.brgenml1lpr # For brother printers
    pkgs.mm_printer_hll2350dw
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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    # extraPackages = with pkgs; [
    #   swaylock
    #   swayidle
    #   wl-clipboard
    #   mako # notification daemon
    #   alacritty # Alacritty is the default terminal in the config
    #   dmenu # Dmenu is the default in the config but i recommend wofi since its wayland native
    # ];
  };

  # gtk.iconCache.enable = true;
  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "pl";
  services.xserver.xkbVariant = "colemak";

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Games
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;
  # Enable zsh
  programs.zsh.enable = true;

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "docker" "kubectl" ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pc = {
    isNormalUser = true;
    extraGroups = [ "wheel" "sway" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh; # Make zsh default shell
  };

  # Auto log in
  services.mingetty.autologinUser = "pc";
  nixpkgs.config.allowUnfree = true;

  environment.enableDebugInfo = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Basic programs
    chromium # Sometimes has something with Firefox doesn't have
    firefox # Main browser
    font-awesome # For icons in i3status-rust
    hicolor-icon-theme # Icons, for thunar?
    libreoffice # Documents editing
    mesa-demos # glxinfo
    nwg-launchers # Launcher of applications with apps icons
    pulseaudio pavucontrol # For audio inputs/outputs
    tango-icon-theme # For icons in thunar
    unstable.i3status-rust # Bar
    unstable.wally-cli # To install moonlander keyboard firmware
    vim
    vscode
    wget
    xfce.thunar xfce.xfconf xfce.tumbler xfce.exo # File browser
    # Games
    teamspeak_client
    unstable.discord
    wineWowPackages.stable
    # NixOS development
    mm_hello # My test package :)
    nix-prefetch-github # For getting sha256 for github packages
    # Programming
    gdb
    git
    hotspot
    linuxPackages.perf
    perf-tools
  ];

  # Available fonts
  fonts = {
    enableFontDir = true;
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09";

}

