{ pkgs, ... }:

let
  t = import ../lib/theme.nix;

  # Convert a #rrggbb hex color to "r, g, b" decimal string for rgba()
  hexToDec =
    h:
    let
      d = {
        "0" = 0;
        "1" = 1;
        "2" = 2;
        "3" = 3;
        "4" = 4;
        "5" = 5;
        "6" = 6;
        "7" = 7;
        "8" = 8;
        "9" = 9;
        "a" = 10;
        "b" = 11;
        "c" = 12;
        "d" = 13;
        "e" = 14;
        "f" = 15;
      };
    in
    d.${builtins.substring 0 1 h} * 16 + d.${builtins.substring 1 2 h};

  toRgb =
    color:
    let
      h = builtins.substring 1 6 color;
      r = hexToDec (builtins.substring 0 2 h);
      g = hexToDec (builtins.substring 2 2 h);
      b = hexToDec (builtins.substring 4 2 h);
    in
    "${toString r}, ${toString g}, ${toString b}";

  rgba = color: alpha: "rgba(${toRgb color}, ${alpha})";

  # Thin wrapper — config files are managed by programs.wlogout, these are display args only.
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    ${pkgs.wlogout}/bin/wlogout --protocol layer-shell -b 2 -c 20 -r 20 -m 20
  '';
in
{
  home.packages = [
    pkgs.hyprlock
    power-menu
  ];

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
        background-color: ${rgba t.base "0.85"};
        font-family: JetBrains Mono Nerd Font, monospace;
      }

      button {
        color: ${t.text};
        background-color: ${rgba t.surface "0.9"};
        border-radius: 12px;
        margin: 6px;
        font-size: 11pt;
        background-repeat: no-repeat;
        background-position: center 25%;
        background-size: 20%;
        padding-top: 70px;
        transition: background-color 0.2s ease, border-color 0.2s ease;
        border: 2px solid ${rgba t.moon.highlightHigh "0.4"};
      }

      button:hover {
        border-color: ${rgba t.subtle "0.8"};
      }

      #lock {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
        color: ${t.foam};
      }
      #lock:hover {
        background-color: ${rgba t.foam "0.15"};
        border-color: ${t.foam};
      }

      #suspend {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/suspend.png");
        color: ${t.iris};
      }
      #suspend:hover {
        background-color: ${rgba t.iris "0.15"};
        border-color: ${t.iris};
      }

      #reboot {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
        color: ${t.gold};
      }
      #reboot:hover {
        background-color: ${rgba t.gold "0.15"};
        border-color: ${t.gold};
      }

      #shutdown {
        background-image: url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
        color: ${t.love};
      }
      #shutdown:hover {
        background-color: ${rgba t.love "0.15"};
        border-color: ${t.love};
      }
    '';
  };
}
