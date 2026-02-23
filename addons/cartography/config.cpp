#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {
            "uksfta_main", 
            "cba_main"
        };
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = "call uksfta_cartography_fnc_preInit";
    };
};

class Extended_DisplayLoad_EventHandlers {
    class RscDisplayMainMap {
        uksfta_cartography_init = "params ['_display']; _display call uksfta_cartography_fnc_initCartography";
    };
};

class CfgFunctions {
    class uksfta_cartography {
        tag = "uksfta_cartography";
        class functions {
            file = "z\uksfta\addons\cartography\functions";
            class preInit {};
            class initCartography {};
            class handleMapDraw {};
            class toggleMode {};
        };
    };
};
