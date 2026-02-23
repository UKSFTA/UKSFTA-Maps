#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {};
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

class CfgFunctions {
    class uksfta_main {
        tag = "uksfta_main";
        class main {
            file = "\z\uksfta\addons\main\functions";
            class preInit {};
        };
    };
};
