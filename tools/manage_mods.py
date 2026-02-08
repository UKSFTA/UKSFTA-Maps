import os
import re
import subprocess
import shutil
import json
import sys

# Configuration
MOD_SOURCES_FILE = "mod_sources.txt"
LOCK_FILE = "mods.lock"
CACHE_DIR = ".workshop_cache"
ADDONS_DIR = "addons"
KEYS_DIR = "keys"
STEAMAPP_ID = "107410"  # Arma 3

def get_mod_info():
    mods = {}
    if not os.path.exists(MOD_SOURCES_FILE):
        return mods
    
    with open(MOD_SOURCES_FILE, "r") as f:
        for line in f:
            clean_line = line.strip()
            if not clean_line or clean_line.startswith("#"):
                continue
            
            # Extract ID
            match = re.search(r"(?:id=)?(\d{8,})", clean_line)
            if match:
                mod_id = match.group(1)
                # Extract Tag (everything after #)
                tag = ""
                if "#" in clean_line:
                    tag = clean_line.split("#", 1)[1].strip()
                mods[mod_id] = tag
    return mods

def run_steamcmd(mod_ids):
    if not mod_ids:
        return
    
    # Prepare steamcmd command
    cmd = ["steamcmd", "+login", "anonymous"]
    for mid in mod_ids:
        cmd.extend(["+workshop_download_item", STEAMAPP_ID, mid])
    cmd.append("+quit")
    
    print(f"--- Updating {len(mod_ids)} mods via SteamCMD ---")
    subprocess.run(cmd, check=True)

def sync_mods(mod_info):
    mod_ids = set(mod_info.keys())
    # tracked_files = { mod_id: [relative_paths_to_installed_files] }
    if os.path.exists(LOCK_FILE):
        with open(LOCK_FILE, "r") as f:
            tracked_files = json.load(f)
    else:
        tracked_files = {}

    current_files = {}
    
    # Path where SteamCMD downloads workshop items
    home = os.path.expanduser("~")
    possible_paths = [
        os.path.join(home, ".steam/steam/steamapps/workshop/content", STEAMAPP_ID),
        os.path.join(home, "Steam/steamapps/workshop/content", STEAMAPP_ID),
        os.path.join(home, ".local/share/Steam/steamapps/workshop/content", STEAMAPP_ID),
        os.path.join("/ext/SteamLibrary/steamapps/workshop/content", STEAMAPP_ID),
        os.path.join(os.getcwd(), "steamapps/workshop/content", STEAMAPP_ID)
    ]
    
    base_workshop_path = None
    for p in possible_paths:
        if os.path.exists(p):
            base_workshop_path = p
            break
            
    if not base_workshop_path:
        print("Error: Could not find Steam Workshop download directory.")
        sys.exit(1)

    # Ensure directories exist
    os.makedirs(ADDONS_DIR, exist_ok=True)
    os.makedirs(KEYS_DIR, exist_ok=True)

    for mid, tag in mod_info.items():
        mod_path = os.path.join(base_workshop_path, mid)
        if not os.path.exists(mod_path):
            print(f"Warning: Mod {mid} not found in workshop cache.")
            continue
            
        tag_display = f" [{tag}]" if tag else ""
        print(f"--- Syncing Mod ID: {mid}{tag_display} ---")
        current_files[mid] = []
        
        for root, dirs, files in os.walk(mod_path):
            for file in files:
                file_lower = file.lower()
                src_path = os.path.join(root, file)
                
                # Handle Addons (.pbo, .bisign)
                if file_lower.endswith((".pbo", ".bisign")):
                    dest_path = os.path.join(ADDONS_DIR, file)
                    shutil.copy2(src_path, dest_path)
                    current_files[mid].append(os.path.relpath(dest_path))
                
                # Handle Keys (.bikey)
                elif file_lower.endswith(".bikey"):
                    dest_path = os.path.join(KEYS_DIR, file)
                    shutil.copy2(src_path, dest_path)
                    current_files[mid].append(os.path.relpath(dest_path))

    # Cleanup removed mods
    for old_mid in list(tracked_files.keys()):
        if old_mid not in mod_ids:
            print(f"--- Cleaning up Mod ID: {old_mid} ---")
            for rel_path in tracked_files[old_mid]:
                if os.path.exists(rel_path):
                    print(f"Removing {rel_path}")
                    os.remove(rel_path)
    
    # Save lockfile
    with open(LOCK_FILE, "w") as f:
        json.dump(current_files, f, indent=2)
    
    sync_hemtt_launch(mod_ids)

def sync_hemtt_launch(mod_ids):
    launch_path = ".hemtt/launch.toml"
    if not os.path.exists(launch_path):
        return
        
    print(f"--- Syncing {launch_path} ---")
    with open(launch_path, "r") as f:
        lines = f.readlines()
        
    new_lines = []
    in_workshop = False
    added = False
    
    for line in lines:
        if "workshop =" in line:
            in_workshop = True
            new_lines.append(line)
            # Add new IDs
            for mid in sorted(mod_ids):
                new_lines.append(f'    "{mid}",\n')
            added = True
            continue
            
        if in_workshop:
            if "]" in line:
                in_workshop = False
                new_lines.append(line)
            continue # Skip old IDs
            
        new_lines.append(line)
        
    with open(launch_path, "w") as f:
        f.writelines(new_lines)

if __name__ == "__main__":
    mod_info = get_mod_info()
    if not mod_info:
        print("No mod IDs found in mod_sources.txt")
        sys.exit(0)
    
    try:
        run_steamcmd(set(mod_info.keys()))
        sync_mods(mod_info)
        print("\nSuccess: Mods synced and cleaned.")
    except Exception as e:
        print(f"\nError: {e}")
        sys.exit(1)
