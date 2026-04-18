_:

{
  programs.waybar = {
    enable = true;

    settings = [
      {
        position = "top";

        modules-left = [
          "hyprland/submap"
          "hyprland/workspaces"
          "custom/arrow10"
          "hyprland/window"
        ];

        modules-right = [
          "custom/power"
          "custom/arrow9"
          "pulseaudio"
          "custom/arrow8"
          "network"
          "custom/arrow7"
          "memory"
          "custom/arrow6"
          "cpu"
          "custom/arrow5"
          "temperature"
          "custom/arrow4"
          "custom/arrow3"
          "custom/arrow2"
          "tray"
          "clock#date"
          "custom/arrow1"
          "clock#time"
        ];

        "clock#time" = {
          interval = 10;
          format = "{:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 20;
          format = "{:%e %b %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          tooltip = false;
          format = " {usage}%";
          format-alt = " {load}";
          states = {
            warning = 70;
            critical = 90;
          };
        };

        memory = {
          interval = 5;
          format = "󰍛 {used:0.1f}G/{total:0.1f}G";
          states = {
            warning = 70;
            critical = 90;
          };
          tooltip = false;
        };

        network = {
          interval = 5;
          format-wifi = " {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "No connection";
          format-alt = " {ipaddr}/{cidr}";
          tooltip = false;
        };

        "hyprland/submap" = {
          format = "{}";
          tooltip = false;
        };

        "hyprland/window" = {
          format = "{}";
          max-length = 30;
          tooltip = false;
        };

        "hyprland/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format = "{name}";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphone = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          tooltip = false;
        };

        temperature = {
          critical-threshold = 90;
          interval = 5;
          format = "{icon} {temperatureC}°";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          tooltip = false;
        };

        tray = {
          icon-size = 18;
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = "power-menu";
        };

        "custom/arrow1" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow2" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow3" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow4" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow5" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow6" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow7" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow8" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow9" = {
          format = "";
          tooltip = false;
        };
        "custom/arrow10" = {
          format = "";
          tooltip = false;
        };
      }
    ];

    style = ''
      @keyframes blink-critical {
        to { background-color: @critical; }
      }

      /* Rose Pine */
      @define-color black    #191724;
      @define-color red      #eb6f92;
      @define-color green    #31748f;
      @define-color yellow   #f6c177;
      @define-color blue     #9ccfd8;
      @define-color purple   #c4a7e7;
      @define-color aqua     #9ccfd8;
      @define-color gray     #908caa;
      @define-color brgray   #6e6a86;
      @define-color brred    #f29ca6;
      @define-color brgreen  #3f8cad;
      @define-color bryellow #f9d297;
      @define-color brblue   #b8daf0;
      @define-color brpurple #d4b4f0;
      @define-color braqua   #b2e2ef;
      @define-color white    #e0def4;
      @define-color bg2      #26233a;

      @define-color warning   @bryellow;
      @define-color critical  @red;
      @define-color mode      @black;
      @define-color unfocused @bg2;
      @define-color focused   @braqua;
      @define-color inactive  @purple;
      @define-color sound     @brpurple;
      @define-color network   @purple;
      @define-color memory    @braqua;
      @define-color cpu       @green;
      @define-color temp      @brgreen;
      @define-color layout    @bryellow;
      @define-color battery   @aqua;
      @define-color date      @black;
      @define-color time      @white;

      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
        box-shadow: none;
        text-shadow: none;
        icon-shadow: none;
      }

      #waybar {
        background: rgba(25,23,36,0.878);
        color: @white;
        font-family: JetBrains Mono Nerd Font, monospace;
        font-size: 14pt;
      }

      #clock,
      #cpu,
      #language,
      #memory,
      #mode,
      #network,
      #pulseaudio,
      #temperature,
      #tray,
      #backlight,
      #idle_inhibitor,
      #disk,
      #user,
      #mpris {
        padding-left: 8pt;
        padding-right: 8pt;
      }

      #mode,
      #memory.critical,
      #cpu.critical,
      #temperature.critical,
      #battery.critical.discharging {
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
        animation-name: blink-critical;
        animation-duration: 1s;
      }

      #network.disconnected,
      #memory.warning,
      #cpu.warning,
      #temperature.warning,
      #battery.warning.discharging {
        color: @warning;
      }

      #mode {
        color: @white;
        background: @mode;
      }

      #workspaces button {
        padding-left: 2pt;
        padding-right: 2pt;
        color: @white;
        background: @unfocused;
      }

      #workspaces button.visible {
        color: @white;
        background: @inactive;
      }

      #workspaces button.active {
        color: @black;
        background: @focused;
      }

      #workspaces button.urgent {
        color: @black;
        background: @warning;
      }

      #workspaces button:hover {
        background: @black;
        color: @white;
      }

      #window {
        margin-right: 35pt;
        margin-left: 35pt;
      }

      #pulseaudio {
        background: @sound;
        color: @black;
      }

      #network {
        background: @network;
        color: @white;
      }

      #memory {
        background: @memory;
        color: @black;
      }

      #cpu {
        background: @cpu;
        color: @white;
      }

      #temperature {
        background: @temp;
        color: @black;
      }

      #language {
        background: @layout;
        color: @black;
      }

      #battery {
        background: @battery;
        color: @white;
      }

      #tray {
        background: @date;
      }

      #clock.date {
        background: @date;
        color: @white;
      }

      #clock.time {
        background: @time;
        color: @black;
      }

      #custom-power {
        padding-left: 8pt;
        padding-right: 8pt;
        color: @red;
        background: transparent;
      }

      #custom-power:hover {
        color: @white;
        background: @red;
      }

      #custom-arrow1 { font-size: 11pt; color: @time;      background: @date;        }
      #custom-arrow2 { font-size: 11pt; color: @date;      background: @layout;      }
      #custom-arrow3 { font-size: 11pt; color: @layout;    background: @battery;     }
      #custom-arrow4 { font-size: 11pt; color: @battery;   background: @temp;        }
      #custom-arrow5 { font-size: 11pt; color: @temp;      background: @cpu;         }
      #custom-arrow6 { font-size: 11pt; color: @cpu;       background: @memory;      }
      #custom-arrow7 { font-size: 11pt; color: @memory;    background: @network;     }
      #custom-arrow8 { font-size: 11pt; color: @network;   background: @sound;       }
      #custom-arrow9 { font-size: 11pt; color: @sound;     background: transparent;  }
      #custom-arrow10 { font-size: 11pt; color: @unfocused; background: transparent; }
    '';
  };
}
