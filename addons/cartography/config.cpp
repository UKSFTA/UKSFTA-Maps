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

class CBA_Settings {
    class uksfta_cartography_mode {
        category = "UKSFTA Cartography";
        displayName = "Active Map Style";
        tooltip = "Choose the high-performance tactical overlay.";
        settingType = "LIST";
        values[] = {"STANDARD", "SATELLITE", "TOPOGRAPHIC", "OS_HYBRID"};
        labels[] = {"Standard (A3)", "High-Fidelity Satellite", "Topographic (Survey)", "OS-Hybrid (Tactical)"};
        default = "STANDARD";
    };
};

// --- Standardized CBA UI HOOK ---
class Extended_DisplayLoad_EventHandlers {
    class RscDisplayMainMap {
        uksfta_cartography = "_this call uksfta_cartography_fnc_initCartography";
    };
};

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
