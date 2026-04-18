_:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # UWSM handles session management (enabled at NixOS level)

    extraConfig = ''
      ################
      ### MONITORS ###
      ################

      monitor=,preferred,auto,auto


      ###################
      ### MY PROGRAMS ###
      ###################

      $terminal = ghostty
      $browser = zen-browser
      $fileManager = dolphin
      $menu = wofi --show drun --allow-images --insensitive --gtk-dark --hide-scroll


      #################
      ### AUTOSTART ###
      #################

      exec-once = nm-applet &
      exec-once = waybar &
      exec-once = wlsunset -l 52.5 -L 13.4 &


      #############################
      ### ENVIRONMENT VARIABLES ###
      #############################

      env = XCURSOR_SIZE,24
      env = HYPRCURSOR_SIZE,24
      env = GTK_THEME,Adwaita:dark

      # NVIDIA + Wayland (required for GTX 1080 / proprietary driver)
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = NVD_BACKEND,direct
      env = WLR_NO_HARDWARE_CURSORS,1
      env = ELECTRON_OZONE_PLATFORM_HINT,wayland
      env = AQ_DRM_DEVICES,/dev/dri/card1


      #####################
      ### LOOK AND FEEL ###
      #####################

      general {
          gaps_in = 2
          gaps_out = 10
          border_size = 2
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          resize_on_border = false
          allow_tearing = false
          layout = master
      }

      decoration {
          rounding = 10
          rounding_power = 2
          active_opacity = 1.0
          inactive_opacity = 1.0

          shadow {
              enabled = true
              range = 4
              render_power = 3
              color = rgba(1a1a1aee)
          }

          blur {
              enabled = true
              size = 3
              passes = 1
              vibrancy = 0.1696
          }
      }

      animations {
          enabled = yes, please :)

          bezier = easeOutQuint,0.23,1,0.32,1
          bezier = easeInOutCubic,0.65,0.05,0.36,1
          bezier = linear,0,0,1,1
          bezier = almostLinear,0.5,0.5,0.75,1.0
          bezier = quick,0.15,0,0.1,1

          animation = global, 1, 10, default
          animation = border, 1, 5.39, easeOutQuint
          animation = windows, 1, 4.79, easeOutQuint
          animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
          animation = windowsOut, 1, 1.49, linear, popin 87%
          animation = fadeIn, 1, 1.73, almostLinear
          animation = fadeOut, 1, 1.46, almostLinear
          animation = fade, 1, 3.03, quick
          animation = layers, 1, 3.81, easeOutQuint
          animation = layersIn, 1, 4, easeOutQuint, fade
          animation = layersOut, 1, 1.5, linear, fade
          animation = fadeLayersIn, 1, 1.79, almostLinear
          animation = fadeLayersOut, 1, 1.39, almostLinear
          animation = workspaces, 1, 1.94, almostLinear, fade
          animation = workspacesIn, 1, 1.21, almostLinear, fade
          animation = workspacesOut, 1, 1.94, almostLinear, fade
      }

      dwindle {
          pseudotile = true
          preserve_split = true
      }

      master {
          new_status = master
      }

      misc {
          force_default_wallpaper = -1
          disable_hyprland_logo = false
      }


      #############
      ### INPUT ###
      #############

      input {
          kb_layout = de,us
          kb_options = caps:escape_shifted_capslock
          follow_mouse = 1
          sensitivity = 0
          accel_profile = flat

          touchpad {
              natural_scroll = false
          }
      }

      device {
          name = epic-mouse-v1
          sensitivity = -0.5
      }


      ###################
      ### KEYBINDINGS ###
      ###################

      $mainMod = SUPER

      bind = $mainMod, Q, exec, $terminal
      bind = $mainMod, W, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, $fileManager
      bind = $mainMod, B, exec, $browser
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, $menu
      bind = $mainMod, P, pseudo,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod SHIFT, S, exec, hyprlock & sleep 0.5 && systemctl suspend -i

      # Focus
      bind = $mainMod, left,  movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up,    movefocus, u
      bind = $mainMod, down,  movefocus, d

      # Pane navigation (vim-style)
      bind = $mainMod, h, movefocus, l
      bind = $mainMod, l, movefocus, r
      bind = $mainMod, k, movefocus, u
      bind = $mainMod, j, movefocus, d

      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10

      # Move window to workspace
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10

      # Special workspace (scratchpad)
      bind = $mainMod, S,           togglespecialworkspace, magic
      bind = $mainMod SHIFT, grave, movetoworkspace,        special:magic

      # Scroll through workspaces
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up,   workspace, e-1

      # Move/resize with mouse
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      # Volume
      bindel = , XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindel = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindel = , XF86AudioMute,        exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindel = , XF86AudioMicMute,     exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      # Brightness
      bindel = , XF86MonBrightnessUp,   exec, brightnessctl s 10%+
      bindel = , XF86MonBrightnessDown, exec, brightnessctl s 10%-

      # Media
      bindl = , XF86AudioNext,  exec, playerctl next
      bindl = , XF86AudioPause, exec, playerctl play-pause
      bindl = , XF86AudioPlay,  exec, playerctl play-pause
      bindl = , XF86AudioPrev,  exec, playerctl previous


      ##############################
      ### WINDOWS AND WORKSPACES ###
      ##############################

      windowrule = match:class .*, suppress_event maximize
      windowrule = match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus on
    '';
  };

  programs.hyprlock = {
    enable = true;
    extraConfig = ''
      general {
        hide_cursor = true
      }

      background {
        monitor =
        color = rgb(232136)
      }

      input-field {
        monitor =
        size = 300, 50
        outline_thickness = 2
        dots_size = 0.2
        dots_spacing = 0.2
        outer_color = rgb(f6c177)
        inner_color = rgb(2a273f)
        font_color = rgb(e0def4)
        fade_on_empty = true
        placeholder_text = <i>Password...</i>
        hide_input = false
        rounding = 8
        check_color = rgb(9ccfd8)
        fail_color = rgb(eb6f92)
        fail_text = <i>$FAIL ($ATTEMPTS)</i>
        position = 0, -120
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:1000] echo "$(date +"%H:%M")"
        color = rgb(e0def4)
        font_size = 72
        font_family = JetBrainsMono Nerd Font
        position = 0, 100
        halign = center
        valign = center
      }

      label {
        monitor =
        text = cmd[update:60000] echo "$(date +"%A, %B %d")"
        color = rgb(908caa)
        font_size = 20
        font_family = JetBrainsMono Nerd Font
        position = 0, 20
        halign = center
        valign = center
      }
    '';
  };
}
