#include "script_component.hpp"
#include "accumulation.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(ADDON_NAME);
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
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
        model = "\z\uksfta\addons\bloodsplatter\models\plane\bloodsplatter_plane.p3d";
        hiddenSelections[] = {"BloodSplatter_Plane"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\environment\data\wet_ca.paa"};
    };
    class UKSFTA_SurfacePlaneSmall: House {
        scope = 1;
        model = "\z\uksfta\addons\bloodsplatter\models\plane\bloodsplatter_smallplane.p3d";
        hiddenSelections[] = {"BloodSplatter_Plane"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\environment\data\blood_ca.paa"};
    };
};

class CfgWorlds {
    class CAWorld {
        class HDRNewPars {
            minAperture = 0.00001; 
            maxAperture = 256; 
            apertureRatioMax = 4.0;
            apertureRatioMin = 10;
            bloomImageScale = 1;
            bloomScale = 0.05; 
            bloomExponent = 1.0;
            bloomLuminanceOffset = 0.8;
            bloomLuminanceScale = 0.1;
            bloomLuminanceExponent = 1.0;
            tonemapMethod = 2; // Linear
            tonemapShoulderStrength = 1.0;
            tonemapLinearStrength = 1.0;
            tonemapLinearAngle = 0.0;
            tonemapToeStrength = 1.0;
            tonemapToeNumerator = 1.0;
            tonemapToeDenominator = 1.0;
            tonemapLinearWhite = 1.0;
            tonemapExposureBias = 0.0;
            tonemapLinearWhiteReinhard = "2.5f";
            eyeAdaptFactorLight = 2.0; 
            eyeAdaptFactorDark = 0.5;
            nvgApertureMin = 10;
            nvgApertureStandard = 13;
            nvgApertureMax = 18;
            nvgStandardAvgLum = 10;
            nvgLightGain = 280;
            nvgTransition = 1;
            nvgTransitionCoefOn = "40.0f";
            nvgTransitionCoefOff = "0.01f";
            nightShiftMinAperture = 0;
            nightShiftMaxAperture = 0.002;
            nightShiftMaxEffect = 0.5;
            nightShiftLuminanceScale = 600;
        };
    };
};

class CfgCloudlets {
    class Default;
    class Blood;
    class UKSFTA_BloodImpact: Blood {
        particleShape = "\z\uksfta\addons\impact\models\gibs\brain_splattered1.p3d"; 
        size[] = {0.05, 0.1};
        color[] = {{1, 1, 1, 1}}; // Use texture color
    };
    class UKSFTA_SkullChunks: Default {
        interval = 0.01;
        particleShape = "\z\uksfta\addons\impact\models\gibs\skull_chunk1.p3d";
        lifeTime = 2.0;
        size[] = {0.1, 0.15};
        color[] = {{1, 1, 1, 1}};
        moveVelocity[] = {0, 2, 0};
        bounceOnSurface = 0.2;
    };
    class UKSFTA_MeatGibs: Default {
        interval = 0.01;
        particleShape = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_Pelvis.p3d";
        lifeTime = 1.5;
        size[] = {0.1, 0.1};
        color[] = {{1, 1, 1, 1}};
        moveVelocity[] = {0, 1, 0};
        bounceOnSurface = 0.1;
    };
    class Missile0: Default {
        interval = 0.002;
        particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";
        particleFSNtieth = 16;
        particleFSIndex = 12;
        particleFSFrameCount = 8;
        lifeTime = 2.8;
        size[] = {1, 2.8, 4};
        color[] = {{0.7, 0.7, 0.7, 0.18}, {0.75, 0.75, 0.75, 0.06}, {0.8, 0.8, 0.8, 0}};
    };
    class FX_MissileTrail_SAM: Default {
        particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";
        interval = 0.0026;
        lifeTime = 10;
        size[] = {2, 6};
        color[] = {{0.8, 0.8, 0.8, 0.8}, {0.9, 0.9, 0.9, 0.4}, {1, 1, 1, 0}};
    };
    class UKSFTA_VehicleExplosion: Default {
        interval = 0.01;
        particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";
        particleFSNtieth = 16;
        particleFSIndex = 12;
        particleFSFrameCount = 8;
        lifeTime = 5;
        size[] = {5, 10, 15};
        color[] = {{0.1, 0.1, 0.1, 0.8}, {0.05, 0.05, 0.05, 0.4}, {0, 0, 0, 0}};
    };
    class UKSFTA_GroundImpact: Default {
        interval = 0.005;
        particleShape = "\A3\data_f\ParticleEffects\Universal\Universal";
        particleFSNtieth = 16;
        particleFSIndex = 12;
        particleFSFrameCount = 8;
        lifeTime = 2;
        size[] = {0.5, 2, 4};
        color[] = {{0.4, 0.35, 0.2, 0.5}, {0.4, 0.35, 0.2, 0}};
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
            class handleAccumulation {};
            class handleAudio {};
            class handleBallistics {};
            class handleCookoff {};
            class handleDriving {};
            class handleStorms {};
            class handleStress {};
            class handleTides {};
            class handleWorldDestruction {};
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
            class handlePooling {};
            class handleModCompat {};
            class handlePhysicality {};
            class handleSpeedOfSound {};
            class handleHeat {};
            class handleConcussion {};
            class handleThermalObjects {};
            class initAccumulationUI {};
            class getSunElevation {};
            class rainEffect {};
            class visualNoise {};
            class localClimate {};
        };
    };
};
