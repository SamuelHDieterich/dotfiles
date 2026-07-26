# Ties the two rofi script modes together into one tabbed picker.
# --screens PATH: path to the "screens" mode script
# --windows PATH: path to the "windows" mode script
while [ $# -gt 0 ]; do
  case "$1" in
    --screens)
      screens_bin=$2
      shift 2
      ;;
    --windows)
      windows_bin=$2
      shift 2
      ;;
    *)
      echo "xdpw-chooser: unknown argument '$1'" >&2
      exit 1
      ;;
  esac
done

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
