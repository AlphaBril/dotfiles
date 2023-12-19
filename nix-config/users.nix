{ config, pkgs, ... }:

{
  users.mutableUsers = false;
  users.users.alphabril = {
    isNormalUser = true;
    description = "alphabril";
    home = "/home/alphabril";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "kvm" "lp" "scanner" ];
    packages = with pkgs; [
    
    ];
    shell = pkgs.fish;
  };
}

