# UKSF Taskforce Alpha - Maps Modpack

Production-grade modpack management and delivery system for UKSFTA. This project utilizes HEMTT for building and custom Python automation for dependency management and Workshop distribution.

## 🛠 Features

- **Automated Mod Management**: Sync external Workshop dependencies via `mod_sources.txt`.
- **Smart Cleanup**: Automatically removes orphaned PBOs and keys when dependencies are removed.
- **HEMTT Integration**: Seamlessly syncs managed mods with HEMTT launch configurations.
- **One-Click Release**: Automated versioning, changelog generation, and dual-deployment to Steam Workshop & GitHub.
- **Security**: Built-in GPG signing enforcement and automated key management.

## 🚀 Getting Started

### Prerequisites

- [HEMTT](https://github.com/vurtual/hemtt)
- [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
- Python 3.6+
- [GitHub CLI (gh)](https://cli.github.com/)

### Installation

1. Clone the repository.
2. Ensure `steamcmd` is in your system PATH.
3. Authenticate with GitHub: `gh auth login`.

## 📦 Workflow

### Managing Dependencies

Add Steam Workshop links or IDs to `mod_sources.txt`:
```text
https://steamcommunity.com/sharedfiles/filedetails/?id=2983546566 # Training Map
```
Then run the sync tool:
```bash
python3 tools/manage_mods.py
```

### Creating a Release

When ready to deploy a new version:
```bash
python3 tools/release.py
```
This will:
1. Prompt for version bump (Patch/Minor/Major).
2. Update `script_version.hpp`.
3. Build the mod using `hemtt release`.
4. Generate a changelog from Git history.
5. Upload to Steam Workshop.
6. Create a GitHub Release with the build artifacts.
7. Tag the repository.

## 📂 Project Structure

- `addons/`: Source code and synchronized PBOs.
- `keys/`: Public signing keys (automatically managed).
- `tools/`: Automation scripts and validation tools.
- `.hemtt/`: HEMTT project configuration and hooks.

## ⚖ License

This project is licensed under the terms of the LICENSE file included in the root directory.
