{ pkgs, hyprpaper-pkg, ... }:

let
  cycleScript = pkgs.writeShellApplication {
    name = "wallpaper-cycle";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.hyprland
    ];
    text = ''
      WALLPAPER_DIR="$HOME/wallpapers"

      wallpaper=$(find "$WALLPAPER_DIR" -type f \( \
        -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \
      \) | shuf -n 1)

      if [ -z "$wallpaper" ]; then
        echo "wallpaper-cycle: no wallpapers found in $WALLPAPER_DIR" >&2
        exit 1
      fi

      hyprctl hyprpaper wallpaper ", $wallpaper"
    '';
  };
in
{
  services.hyprpaper = {
    enable = true;
    package = hyprpaper-pkg;
    settings.ipc = "on";
  };

  systemd.user.services.wallpaper-cycle = {
    Unit = {
      Description = "Set a random wallpaper from ~/wallpapers";
      After = [ "hyprpaper.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${cycleScript}/bin/wallpaper-cycle";
    };
  };

  systemd.user.timers.wallpaper-cycle = {
    Unit.Description = "Cycle wallpaper randomly every 10 minutes";
    Timer = {
      OnActiveSec = "5s";
      OnUnitActiveSec = "10min";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
