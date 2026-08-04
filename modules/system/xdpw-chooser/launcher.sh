# Ties the two rofi script modes together into one tabbed picker.
# Paths are substituted at build time rather than passed as CLI flags:
# xdpw's inih-based ini parser hard-caps a config line at 200 bytes (INI_MAX_LINE),
# and chooser_cmd plus two --flag store paths blew past that,
# silently truncating the value with no error at parse time.
screens_bin="@screens_bin@"
windows_bin="@windows_bin@"

# Script modes hand the selection back via ROFI_INFO on re-invocation rather than stdout
# (see rofi-script(5)), so each mode writes its final "Monitor: "/"Window: " line to this
# shared scratch file instead, which gets cat'd once rofi exits.
XDPW_RESULT=$(mktemp)
export XDPW_RESULT
trap 'rm -f "$XDPW_RESULT"' EXIT

rofi \
  -show screens \
  -modes "screens:$screens_bin,windows:$windows_bin" \
  -kb-move-char-back 'Control+b' \
  -kb-move-char-forward 'Control+f' \
  -kb-mode-previous 'Left' \
  -kb-mode-next 'Right' \
  -theme-str '
    mode-switcher { margin: 12px 0px 0px 0px; spacing: 8px; }
    button { padding: 6px 12px; border-radius: 12px; text-color: @fg2; }
    button.selected { background-color: @bg3; text-color: @fg1; }
    mainbox { children: [ "inputbar", "mode-switcher", "listview" ]; }
  ' \
  || true # Esc/decline exits nonzero; XDPW_RESULT staying empty is the real signal

[ -s "$XDPW_RESULT" ] && cat "$XDPW_RESULT"
