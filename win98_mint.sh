#!/bin/bash

# Windows 98 Transformation Script for Linux Mint
# Installs Chicago95 GTK Theme, Icons, Cursors, Fonts, and Sounds

set -e

echo "=========================================="
echo "  Starting Windows 98 Transformation...   "
echo "=========================================="

# 1. Install required dependencies
echo "[1/5] Installing Git and Python dependencies..."
sudo apt update
sudo apt install -y git python3-pip gtk2-engines-murrine gtk2-engines-pixbuf

# 2. Clone the Chicago95 repository
TEMP_DIR=$(mktemp -d)
echo "[2/5] Downloading Chicago95 theme files..."
git clone --depth 1 https://github.com/grassmunk/Chicago95.git "$TEMP_DIR/Chicago95"

# 3. Install Theme, Icons, Cursors, and Fonts
echo "[3/5] Installing themes, icons, cursors, and fonts..."
mkdir -p ~/.themes ~/.icons ~/.local/share/fonts

cp -r "$TEMP_DIR/Chicago95/Theme/Chicago95" ~/.themes/
cp -r "$TEMP_DIR/Chicago95/Icons/"* ~/.icons/
cp -r "$TEMP_DIR/Chicago95/Cursors/"* ~/.icons/
cp -r "$TEMP_DIR/Chicago95/Fonts/"* ~/.local/share/fonts/

# Refresh font cache
fc-cache -f -v > /dev/null

# 4. Install Sound Theme (Optional/Manual activation)
echo "[4/5] Installing Windows 98 sound effects..."
mkdir -p ~/.local/share/sounds
cp -r "$TEMP_DIR/Chicago95/Sounds/Chicago95" ~/.local/share/sounds/

# 5. Apply Desktop Settings (Detects Cinnamon, MATE, or XFCE)
echo "[5/5] Applying desktop settings..."
DESKTOP=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

if [[ "$DESKTOP" == *"cinnamon"* ]]; then
    echo "Cinnamon desktop detected..."
    gsettings set org.cinnamon.desktop.interface gtk-theme "Chicago95"
    gsettings set org.cinnamon.desktop.interface icon-theme "Chicago95"
    gsettings set org.cinnamon.desktop.interface cursor-theme "Chicago95_Cursor_Black"
    gsettings set org.cinnamon.desktop.wm.preferences theme "Chicago95"
    gsettings set org.cinnamon.theme name "Chicago95"
    
    # Set classic teal background (#008080)
    gsettings set org.cinnamon.desktop.background picture-options 'none'
    gsettings set org.cinnamon.desktop.background primary-color '#008080'

elif [[ "$DESKTOP" == *"xfce"* ]]; then
    echo "XFCE desktop detected..."
    xfconf-query -c xsettings -p /Net/ThemeName -s "Chicago95"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "Chicago95"
    xfconf-query -c xfwm4 -p /general/theme -s "Chicago95"
    xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Chicago95_Cursor_Black"

elif [[ "$DESKTOP" == *"mate"* ]]; then
    echo "MATE desktop detected..."
    gsettings set org.mate.interface gtk-theme "Chicago95"
    gsettings set org.mate.interface icon-theme "Chicago95"
    gsettings set org.mate.peripherals-mouse cursor-theme "Chicago95_Cursor_Black"
    gsettings set org.mate.Marco.general theme "Chicago95"
    gsettings set org.mate.background picture-options 'none'
    gsettings set org.mate.background primary-color '#008080'
else
    echo "Desktop environment ($DESKTOP) not automatically configured."
    echo "Please select 'Chicago95' manually in your System Appearance/Themes settings."
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo "=========================================="
echo "  Transformation Complete!                "
echo "  Log out and back in for full effect.    "
echo "=========================================="
