#!/bin/sh

SCRATCH_FILE="/tmp/scratchpad"
SCRATCH_WIDTH=1600
SCRATCH_HEIGHT=900
ROFI_THEME="${ROFI_THEME:-$HOME/.config/rofi/script_chooser.rasi}"
LOCK_FILE="/tmp/scratchpad.lock"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

die() {
  printf '%s\n' "$*" >&2
  exit 1
}

# jq wrapper — returns empty string instead of "null"
jqr() { jq -r "${1}" 2>/dev/null | grep -v '^null$'; }

active_address() {
  hyprctl activewindow -j | jqr '.address'
}

saved_address() {
  [ -f "$SCRATCH_FILE" ] && cat "$SCRATCH_FILE"
}

window_exists() {
  addr="$1"
  [ -z "$addr" ] && return 1
  hyprctl clients -j |
    jq -e --arg a "$addr" 'any(.[]; .address == $a)' >/dev/null 2>&1
}

scratch_workspace_count() {
  hyprctl workspaces -j |
    jq 'map(select(.name == "special:scratchpad"))[0].windows // 0'
}

active_workspace_id() {
  id="$(hyprctl activeworkspace -j | jqr '.id')"
  # Special workspaces have negative IDs — refuse to move into them
  if [ -z "$id" ] || [ "$id" -lt 0 ] 2>/dev/null; then
    return 1
  fi
  echo "$id"
}

active_workspace_windows() {
  hyprctl activeworkspace -j | jq '.windows // 0'
}

is_floating() {
  hyprctl activewindow -j | jqr '.floating'
}

move_to_current_workspace() {
  addr="$1"
  # Small delay to let Hyprland settle focus state after a scratchpad dispatch
  sleep 0.05
  ws="$(active_workspace_id)" || die "Active workspace is special or unknown; refusing to move scratchpad"
  hyprctl dispatch movetoworkspacesilent "$ws,address:$addr"
  hyprctl dispatch focuswindow "address:$addr"
  hyprctl dispatch alterzorder top,"address:$addr"
}

promote_to_scratchpad() {
  addr="$(active_address)"
  [ -z "$addr" ] && die "No active window"

  if [ "$(is_floating)" = "false" ]; then
    hyprctl --batch \
      "dispatch setfloating; \
             dispatch resizeactive exact $SCRATCH_WIDTH $SCRATCH_HEIGHT; \
             dispatch centerwindow"
  fi

  printf '%s' "$addr" >"$SCRATCH_FILE" ||
    die "Could not write to $SCRATCH_FILE"

  scratchpad
}

# ---------------------------------------------------------------------------
# -t flag: untag current window if it is the saved scratchpad
# (read-only, no lock needed)
# ---------------------------------------------------------------------------

if [ "$1" = "-t" ]; then
  cur="$(active_address)"
  sav="$(saved_address)"
  if [ -n "$sav" ] && [ "$cur" = "$sav" ]; then
    rm -f "$SCRATCH_FILE"
    echo "Scratchpad tag removed."
  else
    echo "Current window is not the saved scratchpad; nothing done."
  fi
  exit 0
fi

# ---------------------------------------------------------------------------
# Main logic — serialised with an exclusive lock.
# Drop concurrent invocations immediately (-n) so rapid keybind presses
# don't queue up and produce double-moves or double-promotes.
# ---------------------------------------------------------------------------

exec 9>"$LOCK_FILE"
flock -n 9 || die "Another instance is already running; dropping invocation."

cur="$(active_address)"
sav="$(saved_address)"

# If we have a saved address, verify the window still exists
if [ -n "$sav" ]; then
  if window_exists "$sav"; then
    echo "Scratchpad window found ($sav)."

    # Current window IS the scratchpad — toggle it away.
    if [ "$cur" = "$sav" ]; then
      scratchpad
      exit 0
    fi

    # No focused window (empty workspace) or a different window is focused —
    # in both cases pull the scratchpad into the current workspace.
    move_to_current_workspace "$sav"
    exit 0
  else
    echo "Saved scratchpad window no longer exists; clearing." >&2
    rm -f "$SCRATCH_FILE"
    sav=""
  fi
fi

# No valid saved scratchpad — check if the special workspace already has
# windows (i.e. scratchpad was previously spawned via the multi-window path).
scratch_wins="$(scratch_workspace_count)"

if [ "$scratch_wins" -eq 0 ] 2>/dev/null; then
  # No scratchpad at all — promote the active window
  promote_to_scratchpad
else
  # Multiple scratchpad candidates — let the user pick via rofi
  scratchpad -g -m "rofi -dmenu -p 'scratchpad: ' -theme $ROFI_THEME"
fi
