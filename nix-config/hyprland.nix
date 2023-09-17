{ nixpkgs, hyprland-input, ... }: system:
{
  programs.hyprland.package = hyprland-input.packages.${system}.hyprland;
  programs.hyprland.enable = true;
  environment.systemPackages = with nixpkgs.legacyPackages.${system}; [
    wl-clipboard
    dunst
    waybar
    wofi
    hyprpaper
    (writeScriptBin "ci" ''wl-copy "$@"'')
    (writeScriptBin "co" ''wl-paste "$@"'')
  ];
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "1";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    QT_SCALE_FACTOR = "2";
  };
  xdg.portal.extraPortals = with nixpkgs.legacyPackages.${system}; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];
# TODO
# + clipboard
# keyboard
# screenshot
# + status bar
# + cursor pointer
# wallpaper
# lock screen
# menu launcher
# X-only software
# + shortcut managers
# custom scripts
}
