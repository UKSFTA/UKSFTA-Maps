#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {
            "UKSFTA_Maps_Main", 
            "A3_Data_F", 
            "A3_Data_F_Curator", 
            "cba_main", 
            "cba_settings",
            "ace_weather",
            "kat_main",
            "3den"
        };
        optionalAddons[] = {"task_force_radio", "acre_main", "ace_uav"};
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = "call uksfta_environment_fnc_preInit";
    };
};

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = "call uksfta_environment_fnc_initEnvironment";
    };
};

class CfgFunctions {
    class uksfta_environment {
        tag = "uksfta_environment";
        class environment {
            file = "z\uksfta\addons\environment\functions";
            class preInit {};
            class initEnvironment {};
            class weatherCycle {};
            class applyVisuals {};
            class getNextState {};
            class analyzeBiome {};
            class handleStorms {};
            class coldBreath {};
            class katMedicalHook {};
            class signalInterference {};
            class aviationTurbulence {};
            class uavInterference {};
        };
    };
};
