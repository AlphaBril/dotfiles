{ config, pkgs, ... }:

{
  environment.variables = {
    EDITOR = "code";
  };
  environment.etc."env-vars.sh" = {
    text = ''
      export PATH="/home/alphabril/me/scripts:$PATH"
      export PATH="/home/alphabril/.config/global_scripts:$PATH"
    '';
    mode = "0115";
  };
}
