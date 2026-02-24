#include "script_component.hpp"
#include "accumulation.hpp"

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

class RscTitles {
    #include "accumulation.hpp"
};

class CfgVehicles {
    class House;
    class UKSFTA_SurfacePlane: House {
        scope = 1;
        model = "\z\uksfta\addons\environment\data\surface_plane.p3d";
        hiddenSelections[] = {"BloodSplatter_Plane"};
    };
    class UKSFTA_SurfacePlaneSmall: House {
        scope = 1;
        model = "\z\uksfta\addons\environment\data\surface_plane_small.p3d";
        hiddenSelections[] = {"BloodSplatter_Plane"};
    };
};

class CfgCloudlets {
    class Default;
    class Blood;
    class UKSFTA_BloodImpact: Blood {
        particleShape = "ser_imp\models\brain_fleck3.p3d"; // Using analysis from SER_IMP
        size[] = {0.1, 0.2};
        color[] = {{0.4, 0, 0, 1}, {0.2, 0, 0, 0}};
    };
};

class ImpactEffectsBlood {
    class Blood {
        simulation = "particles";
        type = "UKSFTA_BloodImpact";
    };
};

class CfgFunctions {
    class uksfta_environment {
        tag = "uksfta_environment";
        class functions {
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
            class initDebug {};
            class handleThermals {};
            class handleLightning {};
            class handleCaustics {};
            class handleWindAudio {};
            class aviationIcing {};
            class handleVehicleDirt {};
            class handleAccumulation {};
            class handlePooling {};
            class handleHeat {};
            class handleConcussion {};
            class initAccumulationUI {};
            class getSunElevation {};
            class rainEffect {};
            class visualNoise {};
            class localClimate {};
        };
    };
};
