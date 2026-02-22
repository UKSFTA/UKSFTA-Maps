#define COMPONENT cartography
#define COMPONENT_BEAUTIFIED Cartography
#define PREFIX uksfta

#define QUOTE(var) #var
#define QQUOTE(var) QUOTE(var)

#define ADDON uksfta_cartography
#define ADDON_NAME UKSFTA Cartography

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {"UKSFTA_Maps_Main", "cba_main", "cba_settings"};
        author = "UKSF Taskforce Alpha";
        version = "1.0.0";
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = "call uksfta_cartography_fnc_preInit";
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = "call uksfta_cartography_fnc_init";
    };
};

class CfgFunctions {
    class uksfta_cartography {
        tag = "uksfta_cartography";
        class functions {
            file = "z\uksfta\addons\cartography\functions";
            class preInit {};
            class init {};
            class handleMapDraw {};
            class toggleMode {};
        };
    };
};
