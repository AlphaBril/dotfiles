{ pkgs, ... }:

rec {
  dark-wallpaper = pkgs.fetchurl {
    url = "https://github.com/MathisP75/summer-day-and-night/blob/main/wallpapers/summer-night.png";
    sha256 = "sha256-eiMZ3xWagyUrI9iTP015cZh4X5x9gz3XXi44IeaOrEM=";
  };

  light-wallpaper = pkgs.fetchurl {
    url = "https://github.com/MathisP75/summer-day-and-night/blob/main/wallpapers/summer-day.png";
    sha256 = "sha256-l65ZSBoll80sSzje8qOkQPQtKnNqKQnMCwJGSRhrkvc=";
  };

  apply-theme-script = pkgs.writeScript "apply-theme" ''
    curr=$(~/.config/global_scripts/get-current-theme.sh)
    if [ "$curr" = "prefer-light" ]; then
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
        feh --bg-scale ${light-wallpaper}
    else
        dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
        feh --bg-scale ${dark-wallpaper}
    fi
  '';

  desktopEntry = {
    name = "Toggle theme";
    exec = ''${pkgs.writeScript "theme" ''
      curr=$(~/.config/global_scripts/get-current-theme.sh)
      if [ "$curr" = "prefer-light" ]; then
        echo 'prefer-dark' > /home/alphabril/.config/global_scripts/currtheme
      else
        echo 'prefer-light' > /home/alphabril/.config/global_scripts/currtheme
      fi
      ${apply-theme-script}
    ''}'';
  };
}

