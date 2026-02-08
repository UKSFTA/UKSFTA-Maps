import os
import sys
import re
import subprocess
import shutil
import getpass
import json
import glob

# Configuration
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VERSION_FILE = os.path.join(PROJECT_ROOT, "addons", "main", "script_version.hpp")
HEMTT_OUT = os.path.join(PROJECT_ROOT, ".hemttout")
RELEASE_DIR = os.path.join(HEMTT_OUT, "release")
STAGING_DIR = os.path.join(HEMTT_OUT, "upload_staging")
PROJECT_TOML = os.path.join(PROJECT_ROOT, ".hemtt", "project.toml")

def get_current_version():
    with open(VERSION_FILE, "r") as f:
        content = f.read()
    
    major = re.search(r"#define\s+MAJOR\s+(\d+)", content).group(1)
    minor = re.search(r"#define\s+MINOR\s+(\d+)", content).group(1)
    patch = re.search(r"#define\s+PATCHLVL\s+(\d+)", content).group(1)
    return f"{major}.{minor}.{patch}", (int(major), int(minor), int(patch))

def bump_version(part="patch"):
    version_str, (major, minor, patch) = get_current_version()
    
    if part == "major":
        major += 1
        minor = 0
        patch = 0
    elif part == "minor":
        minor += 1
        patch = 0
    else: # patch
        patch += 1
        
    new_version = f"{major}.{minor}.{patch}"
    print(f"Bumping version: {version_str} -> {new_version}")
    
    with open(VERSION_FILE, "r") as f:
        content = f.read()
        
    content = re.sub(r"#define\s+MAJOR\s+\d+", f"#define MAJOR {major}", content)
    content = re.sub(r"#define\s+MINOR\s+\d+", f"#define MINOR {minor}", content)
    content = re.sub(r"#define\s+PATCHLVL\s+\d+", f"#define PATCHLVL {patch}", content)
    
    with open(VERSION_FILE, "w") as f:
        f.write(content)
        
    return new_version

def get_workshop_config():
    config = {
        "id": None,
        "tags": ["Mod", "Map"]
    }
    if os.path.exists(PROJECT_TOML):
        with open(PROJECT_TOML, "r") as f:
            for line in f:
                if "workshop_id" in line:
                    config["id"] = line.split("=")[1].strip().strip('"')
                if "workshop_tags" in line:
                    # Expecting: workshop_tags = ["Tag1", "Tag2"]
                    tags_match = re.search(r"\[(.*?)\]", line)
                    if tags_match:
                        config["tags"] = [t.strip().strip('"').strip("'") for t in tags_match.group(1).split(",")]
    return config

def generate_content_list():
    lock_data = {"mods": {}}
    if os.path.exists(LOCK_FILE):
        with open(LOCK_FILE, "r") as f:
            lock_data = json.load(f)
            if "mods" not in lock_data: # handle legacy
                lock_data = {"mods": {}}

    if not os.path.exists("mod_sources.txt"):
        return "[*] [i]No external content listed.[/i]"
    
    content_list = ""
    with open("mod_sources.txt", "r") as f:
        for line in f:
            clean_line = line.strip()
            if not clean_line or clean_line.startswith("#"):
                continue
            
            # Extract ID to look up in lock
            match = re.search(r"(?:id=)?(\d{8,})", clean_line)
            if not match: continue
            mid = match.group(1)
            
            # Get name from tag if present, else from lock
            tag = ""
            if "#" in clean_line:
                tag = clean_line.split("#", 1)[1].strip()
            
            mod_name = tag if tag else lock_data["mods"].get(mid, {}).get("name", f"Mod {mid}")

            # Parse "Category | Name" format if present
            if "|" in mod_name:
                parts = mod_name.split("|")
                cat = parts[0].strip()
                name = parts[1].strip()
                content_list += f"[*] [b]{name}[/b] ({cat})\n"
            else:
                content_list += f"[*] [b]{mod_name}[/b]\n"
    
    if not content_list:
        return "[*] [i]Content list pending update.[/i]"
        
    return content_list

LOCK_FILE = "mods.lock"

def create_vdf(app_id, workshop_id, content_path, changelog, preview_image=None):
    description = ""
    if os.path.exists("workshop_description.txt"):
        with open("workshop_description.txt", "r") as f:
            description = f.read()

    # Inject Included Content
    included_content = generate_content_list()
    description = description.replace("{{INCLUDED_CONTENT}}", included_content)

    config = get_workshop_config()
    tags_vdf = ""
    for i, tag in enumerate(config["tags"]):
        tags_vdf += f'        "{i}" "{tag}"\n'

    preview_line = f'"previewfile" "{preview_image}"' if preview_image else ""
    
    vdf_content = f"""
"workshopitem"
{{
    "appid" "{app_id}"
    "publishedfileid" "{workshop_id}"
    "contentfolder" "{content_path}"
    "changenote" "{changelog}"
    "description" "{description}"
    "tags"
    {{
{tags_vdf}    }}
    {preview_line}
}}
"""
    vdf_path = os.path.join(HEMTT_OUT, "upload.vdf")
    with open(vdf_path, "w") as f:
        f.write(vdf_content)
    return vdf_path

def run_step(description, func, *args):
    print(f"\n=== {description} ===")
    return func(*args)

def main():
    # 0. Check prerequisites
    if not shutil.which("hemtt"):
        print("Error: 'hemtt' not found in PATH.")
        sys.exit(1)
    if not shutil.which("steamcmd"):
        print("Error: 'steamcmd' not found in PATH.")
        sys.exit(1)

    # 1. Get/Bump Version
    print(f"Current version: {get_current_version()[0]}")
    confirm = input("Bump version? [p]atch/[m]inor/[M]ajor/[n]one: ").lower()
    
    new_version = get_current_version()[0]
    if confirm in ['p', 'm', 'major']:
        part = "patch"
        if confirm == 'm': part = "minor"
        if confirm == 'major': part = "major"
        new_version = bump_version(part)
        
        # Git commit version bump
        subprocess.run(["git", "add", VERSION_FILE], check=True)
        subprocess.run(["git", "commit", "-S", "-m", f"chore: bump version to {new_version}"], check=True)

    # 2. Build with HEMTT
    print("Running HEMTT Release Build...")
    subprocess.run(["hemtt", "release"], check=True)

    # 3. Locate and Extract Release
    # Find latest zip in .hemttout/release
    zips = glob.glob(os.path.join(RELEASE_DIR, "*.zip"))
    if not zips:
        print("Error: No release zip found.")
        sys.exit(1)
    latest_zip = max(zips, key=os.path.getctime)
    print(f"Found release: {os.path.basename(latest_zip)}")
    
    if os.path.exists(STAGING_DIR):
        shutil.rmtree(STAGING_DIR)
    os.makedirs(STAGING_DIR)
    
    print(f"Extracting to {STAGING_DIR}...")
    subprocess.run(["unzip", "-q", latest_zip, "-d", STAGING_DIR], check=True)
    
    # 4. Prepare Upload
    ws_config = get_workshop_config()
    workshop_id = ws_config["id"]
    if not workshop_id or workshop_id == "0":
        workshop_id = input("Enter Workshop ID to update: ").strip()
        
    # Generate changelog
    try:
        last_tag = subprocess.check_output(["git", "describe", "--tags", "--abbrev=0"]).decode().strip()
    except:
        try:
            last_tag = subprocess.check_output(["git", "rev-list", "--max-parents=0", "HEAD"]).decode().strip()
        except:
            last_tag = "HEAD" # Fallback
        
    changelog = generate_changelog(last_tag)
    print(f"Changelog:\n{changelog}")
    
    # VDF
    vdf_path = create_vdf("107410", workshop_id, STAGING_DIR, changelog)
    
    # 5. Upload
    print("\n--- Steam Workshop Upload ---")
    username = input("Steam Username: ").strip()
    
    cmd = [
        "steamcmd", 
        "+login", username, 
        "+workshop_build_item", vdf_path,
        "+quit"
    ]
    
    print("Launching SteamCMD... (You may be prompted for password/2FA)")
    try:
        subprocess.run(cmd, check=True)
        print("\nSUCCESS: Mod updated on Workshop.")
        
        # 6. Tag and Push
        if confirm != 'n':
            tag_name = f"v{new_version}"
            print(f"Tagging and pushing git repository: {tag_name}")
            subprocess.run(["git", "tag", "-a", tag_name, "-m", f"Release {new_version}"], check=True)
            subprocess.run(["git", "push", "origin", "main", "--tags"], check=False) # May fail if no remote set

            # 7. GitHub Release
            if shutil.which("gh"):
                print(f"Creating GitHub Release for {tag_name}...")
                gh_cmd = [
                    "gh", "release", "create", tag_name,
                    latest_zip,
                    "--title", f"Release {new_version}",
                    "--notes", changelog
                ]
                subprocess.run(gh_cmd, check=False)
            else:
                print("Warning: 'gh' CLI not found. Skipping GitHub Release creation.")
            
    except subprocess.CalledProcessError as e:
        print(f"\nError during upload: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
