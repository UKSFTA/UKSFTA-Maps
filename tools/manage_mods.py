import os
import re
import subprocess
import shutil
import json
import sys
import urllib.request
import html

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

def get_workshop_metadata(mod_id):
    url = f"https://steamcommunity.com/sharedfiles/filedetails/?id={mod_id}"
    info = {"name": f"Mod {mod_id}", "dependencies": []}
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=10) as response:
            page = response.read().decode('utf-8')
            
            # Title
            match = re.search(r'<div class="workshopItemTitle">(.*?)</div>', page)
            if match:
                info["name"] = html.unescape(match.group(1).strip())
            
            # Dependencies (Required Items)
            deps_section = re.search(r'<div id="requiredItemsContainer">(.*?)</div>\s*</div>', page, re.DOTALL)
            if deps_section:
                dep_matches = re.findall(r'href=".*?id=(\d+)".*?class="requiredItem">.*?<div class="requiredItemText">(.*?)</div>', deps_section.group(1), re.DOTALL)
                for dep_id, dep_name in dep_matches:
                    info["dependencies"].append({
                        "id": dep_id.strip(),
                        "name": html.unescape(dep_name.strip())
                    })
    except Exception as e:
        print(f"Warning: Could not fetch info for mod {mod_id}: {e}")
    return info

def run_steamcmd(mod_ids):
    if not mod_ids:
        return
    cmd = ["steamcmd", "+login", "anonymous"]
    for mid in mod_ids:
        cmd.extend(["+workshop_download_item", STEAMAPP_ID, mid])
    cmd.append("+quit")
    print(f"--- Updating {len(mod_ids)} mods via SteamCMD ---")
    subprocess.run(cmd, check=True)

def sync_mods(mod_info):
    mod_ids = set(mod_info.keys())
    if os.path.exists(LOCK_FILE):
        with open(LOCK_FILE, "r") as f:
            lock_data = json.load(f)
            if "mods" not in lock_data:
                lock_data = {"mods": {}}
    else:
        lock_data = {"mods": {}}

    current_mods = {}
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

    os.makedirs(ADDONS_DIR, exist_ok=True)
    os.makedirs(KEYS_DIR, exist_ok=True)

    for mid, tag in mod_info.items():
        mod_path = os.path.join(base_workshop_path, mid)
        if not os.path.exists(mod_path):
            print(f"Warning: Mod {mid} not found in workshop cache.")
            continue
        
        cached_info = lock_data["mods"].get(mid, {})
        # If we have a tag, it overrides the fetched name, but we still want dependencies
        if not cached_info.get("name") or (not tag and cached_info.get("name").startswith("Mod ")):
            print(f"Fetching metadata for Mod {mid}...")
            ws_info = get_workshop_metadata(mid)
            mod_name = tag if tag else ws_info["name"]
            dependencies = ws_info["dependencies"]
        else:
            mod_name = tag if tag else cached_info.get("name")
            dependencies = cached_info.get("dependencies", [])
            
        print(f"--- Syncing: {mod_name} ({mid}) ---")
        current_mods[mid] = {
            "files": [], 
            "name": mod_name,
            "dependencies": dependencies
        }
        
        for root, dirs, files in os.walk(mod_path):
            for file in files:
                file_lower = file.lower()
                src_path = os.path.join(root, file)
                if file_lower.endswith((".pbo", ".bisign")):
                    dest_path = os.path.join(ADDONS_DIR, file)
                    shutil.copy2(src_path, dest_path)
                    current_mods[mid]["files"].append(os.path.relpath(dest_path))
                elif file_lower.endswith(".bikey"):
                    dest_path = os.path.join(KEYS_DIR, file)
                    shutil.copy2(src_path, dest_path)
                    current_mods[mid]["files"].append(os.path.relpath(dest_path))

    for old_mid in list(lock_data["mods"].keys()):
        if old_mid not in mod_ids:
            print(f"--- Cleaning up Mod ID: {old_mid} ---")
            for rel_path in lock_data["mods"][old_mid].get("files", []):
                if os.path.exists(rel_path):
                    print(f"Removing {rel_path}")
                    os.remove(rel_path)
    
    with open(LOCK_FILE, "w") as f:
        json.dump({"mods": current_mods}, f, indent=2)
    
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
    for line in lines:
        if "workshop =" in line:
            in_workshop = True
            new_lines.append(line)
            for mid in sorted(mod_ids):
                new_lines.append(f'    "{mid}",\n')
            continue
        if in_workshop:
            if "]" in line:
                in_workshop = False
                new_lines.append(line)
            continue
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
