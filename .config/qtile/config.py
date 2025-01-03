# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile import bar, layout, hook

from qtile_extras import widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import subprocess

# from qtile_extras.widget.decorations import PowerLineDecoration
import os

home = os.path.expanduser("~")
# Application defaults
mod = "mod4"
terminal = "ghostty"
browser = "firefox"
ide = "nvim"
files = "thunar"

# Colors source: https://github.com/Pakrohk/Qtile-Dracula/blob/main/config.py
colors = [
    ["#282a36", "#282a36"],  # panel background
    ["#24262F", "#24262F"],  # background for current screen tab
    ["#ffffff", "#ffffff"],  # font color for group names
    ["#BD93F9", "#BD93F9"],  # border line color for current tab
    ["#8d62a9", "#8d62a9"],  # border line color for other tab and odd widgets
    ["#44475A", "#44475A"],  # color for the even widgets
    ["#e1acff", "#e1acff"],  # window name
]


@hook.subscribe.startup
def autostart():
    # subprocess.run('home/albertofp/.config/qtile/autostart.sh')
    subprocess.Popen(["/home/albertofp/.config/qtile/autostart.sh"])


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod],
        "space",
        lazy.widget["keyboardlayout"].next_keyboard(),
        desc="Next keyboard layout.",
    ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "shift"], "space", lazy.layout.flip()),
    Key([mod, "control"], "i", lazy.layout.grow()),
    Key([mod, "control"], "m", lazy.layout.shrink()),
    Key([mod, "control"], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Floating windows
    Key(
        [mod],
        "f",
        lazy.window.toggle_floating(),
        desc="Toggle floating",
    ),
    Key([mod, "shift"], "f", lazy.window.toggle_fullscreen()),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Key([mod], "x", lazy.spawn(rofi_applets + 'rofi_powermenu'), desc="Run powermenu applet"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "control"], "h", lazy.spawn("systemctl suspend"), desc="Suspend"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawn("rofi -show drun")),
    # Applications
    Key([mod, "shift"], "r", lazy.spawn(files), desc="file manager"),
    Key([mod, "shift"], "e", lazy.spawn(ide), desc="code editor"),
    Key([mod, "shift"], "b", lazy.spawn(browser)),
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Screenshot"),
    Key(
        [mod],
        "Print",
        lazy.spawn("flameshot gui -d 2000"),
        desc="Screenshot with delay",
    ),
    # Sound
    Key([mod], "m", lazy.spawn("amixer -q set Master toggle")),
    Key([mod], "Delete", lazy.spawn("playerctl play-pause"), desc="Play/Pause player"),
    Key([mod], "Left", lazy.spawn("playerctl previous"), desc="Skip to previous"),
    Key([mod], "Right", lazy.spawn("playerctl next"), desc="Skip to next"),
    Key(
        [mod],
        "Up",
        lazy.spawn("flock /tmp/amixer.lock amixer set Master 1%+"),
        desc="Increase Volume by 1%",
    ),
    Key(
        [mod],
        "Down",
        lazy.spawn("flock /tmp/amixer.lock amixer set Master 1%-"),
        desc="Lower Volume by 1%",
    ),
    # Media Keys
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("flock /tmp/amixer.lock amixer set Master 1%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("flock /tmp/amixer.lock amixer set Master 1%-")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
]

group_labels = [
    "㊀",
    "㊁",
    "㊂",
    "㊃",
    "㊄",
    "㊅",
    "㊆",
    "㊇",
    "㊈",
    "㊉",
]
groups = [Group(i) for i in "123456789"]
# groups = [Group(i) for i in group_labels]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            Key(
                [mod, "control"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

layout_theme = {
    "margin": 5,
    "border_width": 1,
    "border_focus": "22f6e8",
    "border_normal": "1D2330",
}

layouts = [
    layout.MonadTall(
        **layout_theme,
        ratio=0.6,
    ),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    # layout.Columns(**layout_theme,border_focus_stack=["#6A83F1", "#0E2795"]),
    layout.Max(**layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    layout.MonadWide(**layout_theme),
    # layout.RatioTile(),
    # layout.Tile(**layout_theme),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="JetBrainsMono Nerd Font",
    fontsize=16,
    padding=2,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        # wallpaper="/home/albertofp/Pictures/Wallpapers/ultrawide/FallenTitan_Waifu2x_1080p.png",
        # wallpaper_mode="stretch",
        top=bar.Bar(
            [
                widget.GroupBox(
                    disable_drag=True, rounded=True, highlight_method="block"
                ),
                widget.Sep(
                    linewidth=0, padding=6, foreground=colors[2], background=colors[0]
                ),
                widget.Prompt(),
                widget.Spacer(length=25),
                widget.WindowName(max_chars=50),
                widget.Chord(
                    chords_colors={"launch": ("#ff0000", "#ffffff")},
                    name_transform=lambda name: name.upper(),
                ),
                widget.Wallpaper(
                    directory="/home/albertofp/Pictures/Wallpapers/ultrawide/",
                    random_selection=True,
                    option="stretch",
                    wallpaper_command=None,
                ),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(
                    padding=10,
                    background=colors[2],
                ),
                widget.KeyboardLayout(configured_keyboards=["de", "br"]),
                widget.TextBox(text=" Vol:", padding=1),
                widget.Volume(padding=5),
                # widget.ALSAWidget(mode='icon'),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
                widget.Spacer(length=25),
                widget.Wttr(
                    location={"52.52045,13.40732": "Berlin"},
                    update_interval=300,
                ),
                widget.Spacer(length=25),
                widget.Bluetooth(),
                widget.Wlan(
                    format="{essid} {percent:2.0%}",
                    disconnected_message="Connection lost",
                ),
                widget.Spacer(length=25),
                widget.CurrentLayoutIcon(
                    foregroud=colors[2], background=colors[0], scale=0.8
                ),
            ],
            24,
            background=["#282a36"],
            opacity=0.8
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        # Match(title="RuneLite"),
        Match(title="KCalc"),
        Match(title="RuneLite Launcher"),
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
