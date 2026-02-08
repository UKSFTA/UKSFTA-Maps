# UKSF Taskforce Alpha - Maps Modpack

Production-grade terrain collection and geographical assets for UKSFTA operations.

## 🚀 Quick Start

1. **Initialize Tools**:
   ```bash
   git submodule update --init --remote
   python3 .uksf_tools/setup.py
   ```

2. **Sync Dependencies**:
   ```bash
   python3 tools/manage_mods.py
   ```

3. **Build & Release**:
   ```bash
   python3 tools/release.py
   ```

## 📂 Structure

- `addons/`: Terrain source files and synced PBOs.
- `keys/`: Public signing keys.
- `.uksf_tools/`: Centralized automation submodule.

## 📋 Mod Sources
Terrains and their dependencies are managed in `mod_sources.txt`. Use the `[ignore]` block to exclude large base mods like CBA or ACE if they are handled elsewhere.
