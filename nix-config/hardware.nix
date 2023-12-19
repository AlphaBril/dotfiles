{ config, lib, pkgs, modulesPath, ... }:

rec {
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    useOSProber = true;
    device = "nodev";
    efiInstallAsRemovable = true;
  };

  boot.loader.efi.canTouchEfiVariables = false;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ 
  ];
  boot.kernelParams = [ "i915.force_probe=46a8" ];
  # boots with kernel panic (blinking caps lock), hangs there
  # boot.kernelPackages = pkgs.linuxPackages_latest-libre;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPackages = pkgs.linuxPackages_6_4;

  # boot.kernelPackages =
  # let
  #   my-kernel = (pkgs.linux_6_1.override {
  #     argsOverride = rec {
  #       src = pkgs.fetchzip {
  #         url = "https://github.com/torvalds/linux/archive/refs/tags/v6.2.zip";
  #         sha256 = "sha256-woUP0KZEnwYEzvQEc1OBoCTjkLl8JjYAT4CxFVrfIjU=";
  #       };
  #       version = "6.2";
  #       modDirVersion = "6.2";
  #       };
  #   });
  # in
  # #  pkgs.linuxPackagesFor (
  # #   pkgs.linux-libre.override { linux = my-kernel; });
  # pkgs.linuxPackagesFor my-kernel;

  boot.initrd.luks.devices.root.device = "/dev/disk/by-uuid/6157f167-254e-43d2-934a-9af12e015706";

  fileSystems = 
    let 
      bt = d: {
        device = "/dev/disk/by-uuid/ea00659b-c3ec-4972-be77-9193baf408be";
        fsType = "btrfs";
        options = [ "subvol=@${d}" "compress=zstd" ];
      }; in {

    "/" = bt "";
    "/home" = bt "home";
    "/nix" = bt "nix";
    "/var" = bt "var";

    "/boot" = {
       device = "/dev/disk/by-uuid/A4A5-D3C9";
       fsType = "vfat";
    };
  };

  swapDevices = [
    {
      device = "/swap";
      size = 32 * 1024;
    }
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0=80;
      STOP_CHARGE_THRESH_BAT0=100;

      # https://linrunner.de/tlp/settings/processor.html#cpu-scaling-governor-on-ac-bat

      # Energy perf: power, performance
      # Scaling: powersave, performance

      # Battery
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT="power";

      CPU_SCALING_GOVERNOR_ON_AC="powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC="power";
    };
  };
  hardware.i2c.enable = true;
  hardware.sane.enable = true;

  networking.hostName = "alphabril-tuxedo-nixos"; # Define your hostname.
  # networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
}
