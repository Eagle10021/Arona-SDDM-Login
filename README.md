[English](README.md) | [简体中文](Documents/README.zh.md)

# Blue Archive SDDM Login Theme

A visual adaptation of the "Sugar Candy" SDDM login theme featuring characters and aesthetics from the game *Blue Archive*.

## Recent Updates (Qt 6 Compatibility)
- Updated the theme for full Qt 6 compatibility
- Updated import statements to use `Qt5Compat.GraphicalEffects`
- Fixed property type mismatches (`Control` vs `Item`)
- Explicitly defined signal handler parameters
- Fixed `KeyNavigation` index bounds
- Ensured valid font point sizes
- Fixed contrast issues for username/password fields

![Preview](Previews/Preview.png "Preview")

# Usage

## Manual Installation

1. Download the release archive (e.g., `.tar.gz` or `.zip`) from the releases page.
2. Extract the archive into your SDDM themes directory (typically `/usr/share/sddm/themes`):

```bash
sudo tar -xzvf ~/arona-sddm-login.tar.gz -C /usr/share/sddm/themes
```

3. Configure SDDM to use the new theme by editing its configuration file, typically located at `/etc/sddm.conf` (create it if it does not exist). You can use the default SDDM configuration file as a reference, which can usually be found at `/usr/lib/sddm/sddm.conf.d/sddm.conf`.

In the `[Theme]` section, set the `Current` theme name to `arona-sddm-login`:

```ini
[Theme]
Current=arona-sddm-login
```

## Automatic Installation (Recommended)

The installation script automatically detects and configures the theme resolution for your device.

```bash
git clone https://github.com/Eagle10021/Arona-SDDM-Login.git
cd arona-sddm-login
bash install.sh
```

## KDE Plasma Installation

You can install the theme directly from the KDE store:

1. Open your system settings and navigate to the **Login Screen (SDDM)** section.
2. Click **Get New SDDM Themes...**.
3. Search for the keyword `arona` and click install.

![installation](installation.png)

## Testing/Previewing the Theme

To test the theme without logging out or rebooting, you can run:

```bash
dbus-run-session -- sddm-greeter --test-mode --theme /usr/share/sddm/themes/arona-sddm-login
```
*(Note: Depending on your distribution, the greeter command might be named `sddm-greeter-qt6` instead of `sddm-greeter`).*

## Troubleshooting & Dependencies

This theme is built for SDDM using Qt 6. If you encounter any visual or loading issues, make sure the necessary Qt 6 packages and QML modules are installed:

### Arch Linux
```bash
sudo pacman -S sddm qt6-declarative qt6-5compat qt6-svg
```

### Debian/Ubuntu
```bash
sudo apt install --no-install-recommends sddm qml6-module-qtquick-layouts qml6-module-qtquick-controls qml6-module-qt5compat-graphicaleffects libqt6svg6
```

### RHEL/Fedora
```bash
sudo dnf install sddm qt6-qtdeclarative qt6-qt5compat qt6-qtsvg
```

# Credits & Special Thanks

- This repository is a fork of [Arona SDDM Login](https://github.com/Machillka/arona-sddm-login) by [Machillka](https://github.com/Machillka).
- The original design is based on the [Sugar Candy login](https://github.com/Kangie/sddm-sugar-candy) theme.
