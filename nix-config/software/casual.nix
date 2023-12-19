{ pkgs, sw, ... }: {
  environment.systemPackages = with pkgs; [
    spotify
    slack
    discord
    libreoffice
    firefox
    chromium
    kitty
    gimp
    vlc
    pamixer
    pavucontrol
    signal-desktop
    openvpn
    unzip
    upower
    zip
    virt-manager
    qemu_kvm
    ffmpeg
    gnome.gnome-system-monitor
  ];
}
