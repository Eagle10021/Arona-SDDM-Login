set -euo pipefail

# ---------- 0. Sanity checks ----------
if [[ "$(id -u)" -eq 0 ]]; then
  echo "❌  Don’t run as root. Let the script sudo itself when needed." >&2
  exit 2
fi

# Ensure we’re *in* a candidate theme dir (must contain at least Main.qml)
if [[ ! -f "Main.qml" ]]; then
  echo "❌  Main.qml not found – are you inside the theme folder?" >&2
  exit 1
fi

THEME_SRC="$(pwd)"
THEME_NAME="$(basename "$THEME_SRC")"
THEME_DST="/usr/share/sddm/themes/$THEME_NAME"
THEME_CONF="$THEME_SRC/theme.conf"

# ---------- 1. Ask the user for resolution ----------

# ---------- calculate the resolution
detect_default_res() {
  local xrandr_mode
  if xrandr_mode=$(command -v xrandr >/dev/null 2>&1 && xrandr | grep -m1 '\*'); then
    echo "$xrandr_mode" | awk '{print $1}'
  else
    echo "1920x1080"
  fi
}
DEFAULT_RES="$(detect_default_res)"

read -rp "Input Your own resolution (e.g. 1920x1080), defalut is ${DEFAULT_RES} " RES

RES="${RES:-$DEFAULT_RES}"

if [[ "$RES" =~ ^([0-9]{3,5})x([0-9]{3,5})$ ]]; then
    WIDTH="${BASH_REMATCH[1]}"
    HEIGHT="${BASH_REMATCH[2]}"
else
    echo "✖️  Invalid format. Use <width>x<height>, digits only."
    WIDTH="${DEFAULT_RES%x*}"
    HEIGHT="${DEFAULT_RES#*x}"
fi
echo "→ 使用分辨率 ${WIDTH}×${HEIGHT}"



# ---------- 2. Patch or create theme.conf locally ----------
touch "$THEME_CONF"  # create if missing
patch_key() {
  local key="$1" val="$2"
  if grep -qE "^${key}=" "$THEME_CONF"; then
    sed -i "s|^${key}=.*|${key}=${val}|" "$THEME_CONF" \
      || { echo "✖️  Could not patch ${key}." >&2; exit 4; }
  else
    echo "${key}=${val}" >>"$THEME_CONF"
  fi
}
patch_key ScreenWidth  "$WIDTH"
patch_key ScreenHeight "$HEIGHT"
echo "✔️  theme.conf updated: ${WIDTH}×${HEIGHT}"

# ---------- 3. Copy the theme with sudo ----------
echo "🔑  Copying to ${THEME_DST} (sudo)…"
sudo mkdir -p "$(dirname "$THEME_DST")" \
  && sudo rm -rf "$THEME_DST" \
  && sudo cp -a "$THEME_SRC" "$THEME_DST" \
  || { echo "✖️  Copy failed." >&2; exit 3; }
echo "✔️  Installed theme at ${THEME_DST}"

# ---------- 4. (Optional) print quick-test hint ----------
cat <<EOF

Next steps:
  • Set Current=$THEME_NAME in /etc/sddm.conf or sddm.conf.d/*.conf
  • Quick preview (no reboot needed):
      dbus-run-session -- sddm-greeter --test-mode --theme "$THEME_DST"
EOF