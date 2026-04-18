{ pkgs, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    ${pkgs.wlogout}/bin/wlogout \
      --protocol layer-shell \
      --layout "$HOME/.config/wlogout/layout" \
      --css "$HOME/.config/wlogout/style.css" \
      -b 4 \
      -c 20 \
      -r 20 \
      -m 20
  '';
in
{
  home.packages = [
    pkgs.wlogout
    pkgs.hyprlock
    power-menu
  ];

  xdg.configFile."wlogout/layout".text = ''
    {
      "label": "lock",
      "action": "hyprlock",
      "text": "Lock",
      "keybind": "l"
    }
    {
      "label": "suspend",
      "action": "hyprlock & sleep 0.5 && systemctl suspend -i",
      "text": "Sleep",
      "keybind": "s"
    }
    {
      "label": "reboot",
      "action": "systemctl reboot",
      "text": "Restart",
      "keybind": "r"
    }
    {
      "label": "shutdown",
      "action": "systemctl poweroff",
      "text": "Shutdown",
      "keybind": "p"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      background-image: none;
      box-shadow: none;
      border: none;
      outline: none;
    }

    window {
      background-color: rgba(25, 23, 36, 0.85);
      font-family: JetBrains Mono Nerd Font, monospace;
    }

    button {
      color: #e0def4;
      background-color: rgba(31, 29, 46, 0.9);
      border-radius: 12px;
      margin: 10px;
      font-size: 16pt;
      background-repeat: no-repeat;
      background-position: center 30%;
      background-size: 25%;
      padding-top: 140px;
      transition: background-color 0.2s ease, border-color 0.2s ease;
      border: 2px solid rgba(86, 82, 110, 0.4);
    }

    button:hover,
    button:focus {
      border-color: rgba(144, 140, 170, 0.8);
    }

    #lock {
      background-image: url("${pkgs.wlogout}/share/wlogout/icons/lock.png");
      color: #9ccfd8;
    }
    #lock:hover,
    #lock:focus {
      background-color: rgba(156, 207, 216, 0.15);
      border-color: #9ccfd8;
    }

    #suspend {
      background-image: url("${pkgs.wlogout}/share/wlogout/icons/suspend.png");
      color: #c4a7e7;
    }
    #suspend:hover,
    #suspend:focus {
      background-color: rgba(196, 167, 231, 0.15);
      border-color: #c4a7e7;
    }

    #reboot {
      background-image: url("${pkgs.wlogout}/share/wlogout/icons/reboot.png");
      color: #f6c177;
    }
    #reboot:hover,
    #reboot:focus {
      background-color: rgba(246, 193, 119, 0.15);
      border-color: #f6c177;
    }

    #shutdown {
      background-image: url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png");
      color: #eb6f92;
    }
    #shutdown:hover,
    #shutdown:focus {
      background-color: rgba(235, 111, 146, 0.15);
      border-color: #eb6f92;
    }
  '';
}
