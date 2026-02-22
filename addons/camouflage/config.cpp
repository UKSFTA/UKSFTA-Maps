#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {
            "UKSFTA_Maps_Main", 
            "cba_main", 
            "cba_settings", 
            "uksfta_environment"
        };
        optionalAddons[] = {"lambs_danger", "VCOM_AI"};
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = "call uksfta_camouflage_fnc_preInit";
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = "call uksfta_camouflage_fnc_init";
    };
};

class CfgFunctions {
    class uksfta_camouflage {
        tag = "uksfta_camouflage";
        class functions {
            file = "\z\uksfta\addons\camouflage\functions";
            class preInit {};
            class init {};
            class applyCamouflage {};
        };
    };
};
