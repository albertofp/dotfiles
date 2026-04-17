{ config, ... }:

{
  # Using mkOutOfStoreSymlink so edits to files in the dotfiles repo are
  # reflected immediately — no rebuild needed.
  home.file =
    let
      dotfiles = "/home/alberto/dotfiles";
      link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
    in
    {
      ".gitconfig".source = link ".gitconfig";
      ".gitconfig-jet".source = link ".gitconfig-jet";
      ".config/nvim".source = link ".config/nvim";
      ".config/ghostty".source = link ".config/ghostty";
      ".config/hypr".source = link ".config/hypr";
      ".config/waybar".source = link ".config/waybar";
    };
}
