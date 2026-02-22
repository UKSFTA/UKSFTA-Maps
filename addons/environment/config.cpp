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
            "cba_settings"
        };
        optionalAddons[] = {
            "ace_weather",
            "ace_goggles",
            "ace_uav",
            "kat_main",
            "task_force_radio",
            "acre_main",
            "lambs_danger",
            "VCOM_AI"
        };
        author = "UKSF Taskforce Alpha";
        VERSION_CONFIG;
    };
};

class CBA_Settings {
    class uksfta_environment_preset {
        category = "UKSFTA Environment";
        displayName = "Operational Mode";
        tooltip = "ARCADE: Easier visibility. REALISM: Full Diamond Standard.";
        settingType = "LIST";
        values[] = {"ARCADE", "REALISM"};
        labels[] = {"Arcade (Relaxed)", "Realism (Diamond Standard)"};
        default = "REALISM";
    };
    class uksfta_environment_enabled {
        category = "UKSFTA Environment";
        displayName = "Enable Framework (Server)";
        settingType = "CHECKBOX";
        default = 1;
    };
    class uksfta_environment_enableThermals {
        category = "UKSFTA Environment";
        displayName = "Enable Thermal Realism";
        settingType = "CHECKBOX";
        default = 1;
    };
    class uksfta_environment_enableSignalInterference {
        category = "UKSFTA Environment";
        displayName = "Enable Signal Interference";
        settingType = "CHECKBOX";
        default = 1;
    };
    class uksfta_environment_thermalIntensity {
        category = "UKSFTA Environment";
        displayName = "Thermal Degradation Strength";
        settingType = "SLIDER";
        values[] = {0, 5, 1, 1};
        default = 1;
    };
    class uksfta_environment_interferenceIntensity {
        category = "UKSFTA Environment";
        displayName = "Signal Interference Intensity";
        settingType = "SLIDER";
        values[] = {0, 5, 1, 1};
        default = 1;
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
            file = "\z\uksfta\addons\environment\functions";
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
            class initDebug {};
            class handleThermals {};
            class getSunElevation {};
        };
    };
};
