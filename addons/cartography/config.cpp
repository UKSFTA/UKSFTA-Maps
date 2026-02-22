#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {"UKSFTA_Maps_Main", "cba_main"};
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

// --- NATIVE UI HOOK ---
// IDD 12 is the main map. RscDisplayEmpty is often used as a base.
class RscDisplayMission {
    onLoad = "[_this select 0] call uksfta_cartography_fnc_initCartography";
};

class RscDisplayGetReady: RscDisplayMission {};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = "call uksfta_cartography_fnc_preInit";
    };
};

class CfgFunctions {
    class uksfta_cartography {
        tag = "uksfta_cartography";
        class functions {
            file = "\z\uksfta\addons\cartography\functions";
            class preInit {};
            class initCartography {};
            class handleMapDraw {};
            class toggleMode {};
        };
    };
};
