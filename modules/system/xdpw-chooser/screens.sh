# Rofi script mode (rofi-script(5)) listing enabled outputs.
# ROFI_RETV=0: initial call — print the row list.
# ROFI_RETV=1: user selected a row — its raw output name comes back via ROFI_INFO.
case "${ROFI_RETV:-0}" in
  0)
    printf '\0prompt\x1fScreen\n'
    printf '\0no-custom\x1ftrue\n' # reject typed text that doesn't match a listed output
    wlr-randr --json | jq -r '.[] | select(.enabled) | .name' | while IFS= read -r name; do
      # "info" carries the raw name through untouched, even though the visible label differs
      printf 'Entire screen — %s\0info\x1f%s\n' "$name" "$name"
    done
    ;;
  1)
    # xdpw's chooser protocol expects exactly this "Monitor: <name>" line on stdout
    printf 'Monitor: %s\n' "$ROFI_INFO" > "$XDPW_RESULT"
    ;;
esac
