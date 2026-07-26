# Rofi script mode (rofi-script(5)) listing open windows (toplevels).
# ROFI_RETV=0: initial call — print the row list.
# ROFI_RETV=1: user selected a row — its raw toplevel identifier comes back via ROFI_INFO.
case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1fWindow\n'
    printf '\0no-custom\x1ftrue\n' # reject typed text that doesn't match a listed window
    lswt -j | jq -r '.toplevels[] | "\(.identifier)\t\(."app-id"): \(.title)"' \
      | while IFS=$'\t' read -r id label; do
          # "info" carries the raw toplevel id through untouched; only the label is shown
          printf 'Window — %s\0info\x1f%s\n' "$label" "$id"
        done
    ;;
  1)
    # xdpw's chooser protocol expects exactly this "Window: <id>" line on stdout
    printf 'Window: %s\n' "$ROFI_INFO" > "$XDPW_RESULT"
    ;;
esac
