{ config, ... }:

let
  dotfiles = "/home/alberto/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  programs.waybar = {
    enable = true;
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
        -gtk-icon-shadow: none;
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

      #mode { color: @white; background: @mode; }

      #workspaces button {
        padding-left: 2pt;
        padding-right: 2pt;
        color: @white;
        background: @unfocused;
      }
      #workspaces button.visible { color: @white; background: @inactive; }
      #workspaces button.active  { color: @black; background: @focused;  }
      #workspaces button.urgent  { color: @black; background: @warning;  }
      #workspaces button:hover   { background: @black; color: @white;    }

      #window      { margin-right: 35pt; margin-left: 35pt; }
      #pulseaudio  { background: @sound;   color: @black; }
      #network     { background: @network; color: @white; }
      #memory      { background: @memory;  color: @black; }
      #cpu         { background: @cpu;     color: @white; }
      #temperature { background: @temp;    color: @black; }
      #language    { background: @layout;  color: @black; }
      #battery     { background: @battery; color: @white; }
      #tray        { background: @date; }
      #clock.date  { background: @date; color: @white; }
      #clock.time  { background: @time; color: @black; }

      #custom-power {
        padding-left: 8pt;
        padding-right: 8pt;
        color: @red;
        background: @date;
      }
      #custom-power:hover { color: @white; background: @red; }

      #custom-arrow1      { font-size: 11pt; color: @time;      background: @date;       }
      #custom-arrow2      { font-size: 11pt; color: @date;      background: @layout;     }
      #custom-arrow3      { font-size: 11pt; color: @layout;    background: @battery;    }
      #custom-arrow4      { font-size: 11pt; color: @battery;   background: @temp;       }
      #custom-arrow5      { font-size: 11pt; color: @temp;      background: @cpu;        }
      #custom-arrow6      { font-size: 11pt; color: @cpu;       background: @memory;     }
      #custom-arrow7      { font-size: 11pt; color: @memory;    background: @network;    }
      #custom-arrow8      { font-size: 11pt; color: @network;   background: @sound;      }
      #custom-arrow9      { font-size: 11pt; color: @sound;     background: @date;       }
      #custom-arrow10     { font-size: 11pt; color: @unfocused; background: transparent; }
      #custom-arrow-power { font-size: 11pt; color: @date;      background: transparent; }
    '';
  };

  # Config is a JSONC file kept in the dotfiles repo and symlinked so it can
  # be edited live without a rebuild (icons are unicode bytes — easier in JSONC
  # than embedded in Nix strings).
  xdg.configFile."waybar/config.jsonc".source = link ".config/waybar/config.jsonc";
}
