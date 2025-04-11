{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
    useOSProber = true;
  };

  # Networking
  networking.hostName = "nix";
  networking.networkmanager.enable = true;

  # Time and localization
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "pl_PL.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # X11 and XFCE
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.xfce.enable = true;
  };
  # VideoDriver
  services.xserver.videoDrivers = lib.mkForce [];   # automatic detect drivers
  #services.xserver.videoDrivers = [ "nouveau" ];   # Or use "vesa", "intel", "amdgpu", etc.


  # Printing
  services.printing.enable = true;

  # Sound
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  users.users.ssobol = {
    isNormalUser = true;
    description = "Siergej";
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.fish;
    #initialPassword = "test77";
    # Remove initialPassword for security; set via `passwd`
    packages = with pkgs; [
      vscode
      google-chrome
      vlc
      krita
      gimp
      tree
      ark
    ];
  };
  programs.fish.enable = true;

  # SSH
  services.openssh.enable = true;

  # Firefox
  programs.firefox.enable = true;

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    curl
    gitFull
    gh
    python312  # Match nix-shell
    python312Packages.pip
    nodejs    # For development
    mc
    firefox
    btop
    gparted
    gedit
    gnome-terminal
    fish
    starship
  ];

  # Starship
  programs.starship = {
    enable = true;
  };

  # System version
  system.stateVersion = "24.11";
}