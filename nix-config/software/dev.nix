{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    awscli
    git
    vim
    jetbrains.datagrip
  ];
}
