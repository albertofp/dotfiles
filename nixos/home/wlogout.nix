{ pkgs, ... }:

let
  t = import ../lib/theme.nix;

  # Thin wrapper — config files are managed by programs.wlogout, these are display args only.
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    ${pkgs.wlogout}/bin/wlogout --protocol layer-shell -b 2 -c 20 -r 20 -m 20
  '';
in
{
  home.packages = [ power-menu ];

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "suspend";
        action = "hyprlock & sleep 0.5 && systemctl suspend -i";
        text = "Sleep";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Restart";
        keybind = "r";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "p";
      }
    ];
    style = ''
      * {
        background-image: none;
        box-shadow: none;
        border: none;
        outline: none;
      }

      window {
        background-color: ${t.base}D9;
        font-family: JetBrains Mono Nerd Font, monospace;
      }

      button {
        color: ${t.text};
        background-color: ${t.surface}E6;
        border-radius: 12px;
        margin: 6px;
        font-size: 11pt;
        background-repeat: no-repeat;
        background-position: center 25%;
        background-size: 20%;
        padding-top: 70px;
        transition: background-color 0.2s ease, border-color 0.2s ease;
        border: 2px solid ${t.moon.highlightHigh}66;
      }

      button:hover {
        border-color: ${t.subtle}CC;
      }

      #lock {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
        color: ${t.foam};
      }
      #lock:hover {
        background-color: ${t.foam}26;
        border-color: ${t.foam};
      }

      #suspend {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/suspend.png");
        color: ${t.iris};
      }
      #suspend:hover {
        background-color: ${t.iris}26;
        border-color: ${t.iris};
      }

      #reboot {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
        color: ${t.gold};
      }
      #reboot:hover {
        background-color: ${t.gold}26;
        border-color: ${t.gold};
      }

      #shutdown {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
        color: ${t.love};
      }
      #shutdown:hover {
        background-color: ${t.love}26;
        border-color: ${t.love};
      }
    '';
  };
}
