# Rose Pine color palettes
# https://rosepinetheme.com/palette
#
# Usage in a module:
#   let t = import ../lib/theme.nix; in
#   # t.base, t.foam, t.moon.base          — 6-digit hex strings  (#rrggbb)
#   # t.rgb.base, t.rgb.foam               — "r, g, b" strings for rgba()
#   # t.moon.rgb.base                      — Moon variant rgb strings
#
# GTK3 does not support 8-digit hex (#rrggbbAA).  Use rgba(${t.rgb.foo}, α)
# wherever transparency is needed.
{
  # ── Rose Pine (main) ───────────────────────────────────────────────────────
  base = "#191724";
  surface = "#1f1d2e";
  overlay = "#26233a";
  muted = "#6e6a86";
  subtle = "#908caa";
  text = "#e0def4";
  love = "#eb6f92";
  gold = "#f6c177";
  rose = "#ebbcba";
  pine = "#31748f";
  foam = "#9ccfd8";
  iris = "#c4a7e7";
  highlightLow = "#21202e";
  highlightMed = "#403d52";
  highlightHigh = "#524f67";

  # "r, g, b" strings — use as: rgba(${t.rgb.base}, 0.85)
  rgb = {
    base = "25, 23, 36";
    surface = "31, 29, 46";
    overlay = "38, 35, 58";
    muted = "110, 106, 134";
    subtle = "144, 140, 170";
    text = "224, 222, 244";
    love = "235, 111, 146";
    gold = "246, 193, 119";
    rose = "235, 188, 186";
    pine = "49, 116, 143";
    foam = "156, 207, 216";
    iris = "196, 167, 231";
    highlightLow = "33, 32, 46";
    highlightMed = "64, 61, 82";
    highlightHigh = "82, 79, 103";
  };

  # ── Rose Pine Moon ─────────────────────────────────────────────────────────
  moon = {
    base = "#232136";
    surface = "#2a273f";
    overlay = "#393552";
    muted = "#6e6a86";
    subtle = "#908caa";
    text = "#e0def4";
    love = "#eb6f92";
    gold = "#f6c177";
    rose = "#ea9a97";
    pine = "#3e8fb0";
    foam = "#9ccfd8";
    iris = "#c4a7e7";
    highlightLow = "#2a283e";
    highlightMed = "#44415a";
    highlightHigh = "#56526e";

    rgb = {
      base = "35, 33, 54";
      surface = "42, 39, 63";
      overlay = "57, 53, 82";
      muted = "110, 106, 134";
      subtle = "144, 140, 170";
      text = "224, 222, 244";
      love = "235, 111, 146";
      gold = "246, 193, 119";
      rose = "234, 154, 151";
      pine = "62, 143, 176";
      foam = "156, 207, 216";
      iris = "196, 167, 231";
      highlightLow = "42, 40, 62";
      highlightMed = "68, 65, 90";
      highlightHigh = "86, 82, 110";
    };
  };
}
