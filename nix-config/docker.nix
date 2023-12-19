{ pkgs, ... }:
{
  users.users.alphabril.extraGroups = [ "docker" ];
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
    docker docker-compose
  ];
}
