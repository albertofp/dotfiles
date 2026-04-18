{ pkgs, ... }:

let
  power-menu = pkgs.writeShellScriptBin "power-menu" ''
    ${pkgs.wlogout}/bin/wlogout \
      --protocol layer-shell \
      --layout "$HOME/.config/wlogout/layout" \
      --css "$HOME/.config/wlogout/style.css" \
      -b 4 \
      -T 40 \
      -B 960 \
      -c 0 \
      -r 0
  '';
in
{
  home.packages = [
    pkgs.wlogout
    pkgs.hyprlock
    power-menu
  ];

  xdg.configFile."wlogout/layout".text = ''
    [
      {
        "label": "lock",
        "action": "hyprlock",
        "text": "Lock",
        "keybind": "l"
      },
      {
        "label": "suspend",
        "action": "hyprlock & sleep 0.5 && systemctl suspend -i",
        "text": "Sleep",
        "keybind": "s"
      },
      {
        "label": "reboot",
        "action": "systemctl reboot",
        "text": "Restart",
        "keybind": "r"
      },
      {
        "label": "shutdown",
        "action": "systemctl poweroff",
        "text": "Shutdown",
        "keybind": "p"
      }
    ]
  '';

  xdg.configFile."wlogout/style.css".text = ''
    /* Rose Pine Moon */
    * {
      background-image: none;
      box-shadow: none;
      border: none;
      outline: none;
    }

    window {
      background-color: rgba(35, 33, 54, 0.92);
    }

    button {
      background-color: transparent;
      color: #908caa;
      font-family: JetBrains Mono Nerd Font, monospace;
      font-size: 13pt;
      border-radius: 0;
      margin: 0;
      padding: 0;
      border-right: 1px solid rgba(86, 82, 110, 0.4);
      transition: background-color 0.15s ease, color 0.15s ease;
    }

    button:last-child {
      border-right: none;
    }

    button:hover,
    button:focus {
      background-color: rgba(86, 82, 110, 0.35);
      color: #e0def4;
    }

    button#lock {
      color: #9ccfd8;
    }
    button#lock:hover,
    button#lock:focus {
      background-color: rgba(156, 207, 216, 0.15);
      color: #9ccfd8;
    }

    button#suspend {
      color: #c4a7e7;
    }
    button#suspend:hover,
    button#suspend:focus {
      background-color: rgba(196, 167, 231, 0.15);
      color: #c4a7e7;
    }

    button#reboot {
      color: #f6c177;
    }
    button#reboot:hover,
    button#reboot:focus {
      background-color: rgba(246, 193, 119, 0.15);
      color: #f6c177;
    }

    button#shutdown {
      color: #eb6f92;
    }
    button#shutdown:hover,
    button#shutdown:focus {
      background-color: rgba(235, 111, 146, 0.15);
      color: #eb6f92;
    }
  '';
}
