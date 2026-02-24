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
        hiddenSelections[] = {"BloodSplatter_Plane", "BloodSplatter_Blood"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\environment\data\wet_ca.paa", "z\uksfta\addons\bloodsplatter\models\plane\bloodsplatter_plane_blood_ca.paa"};
    };
    class UKSFTA_SurfacePlaneSmall: House {
        scope = 1;
        model = "\z\uksfta\addons\bloodsplatter\models\plane\bloodsplatter_smallplane.p3d";
        hiddenSelections[] = {"BloodSplatter_Plane", "Burn"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\environment\data\blood_ca.paa", "z\uksfta\addons\environment\data\burn_ca.paa"};
    };
    // Impact Effect Models
    class Thing;
    class UKSFTA_Impact_AmmoBelt_Links: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\AmmoBelt_Links.p3d";
    };
    class UKSFTA_Impact_CraterLong: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\CraterLong.p3d";
    };
    class UKSFTA_Impact_CraterLong_small: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\CraterLong_small.p3d";
    };
    class UKSFTA_Impact_Dirt_big: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Dirt_big.p3d";
    };
    class UKSFTA_Impact_Embers: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Embers.p3d";
    };
    class UKSFTA_Impact_Explosion_02: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_02.p3d";
    };
    class UKSFTA_Impact_Explosion_04: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_04.p3d";
    };
    class UKSFTA_Impact_Explosion_05: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_05.p3d";
    };
    class UKSFTA_Impact_Explosion_07: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_07.p3d";
    };
    class UKSFTA_Impact_Explosion_08: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_08.p3d";
    };
    class UKSFTA_Impact_Explosion_09: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_09.p3d";
    };
    class UKSFTA_Impact_Explosion_11: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_11.p3d";
    };
    class UKSFTA_Impact_Explosion_12: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Explosion_12.p3d";
    };
    class UKSFTA_Impact_GlassParts_00: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_00.p3d";
    };
    class UKSFTA_Impact_GlassParts_01: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_01.p3d";
    };
    class UKSFTA_Impact_GlassParts_02: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_02.p3d";
    };
    class UKSFTA_Impact_GlassParts_03: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_03.p3d";
    };
    class UKSFTA_Impact_GlassParts_04: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_04.p3d";
    };
    class UKSFTA_Impact_GlassParts_05: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_05.p3d";
    };
    class UKSFTA_Impact_GlassParts_06: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassParts_06.p3d";
    };
    class UKSFTA_Impact_GlassShards: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GlassShards.p3d";
    };
    class UKSFTA_Impact_GrassMesh: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\GrassMesh.p3d";
    };
    class UKSFTA_Impact_Grass_volume: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Grass_volume.p3d";
    };
    class UKSFTA_Impact_HitEffect: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\HitEffect.p3d";
    };
    class UKSFTA_Impact_LargeFire_01: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\LargeFire_01.p3d";
    };
    class UKSFTA_Impact_Leaves: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Leaves.p3d";
    };
    class UKSFTA_Impact_Leaves_Green: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Leaves_Green.p3d";
    };
    class UKSFTA_Impact_Meat_ca: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Meat_ca.p3d";
    };
    class UKSFTA_Impact_Mud: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Mud.p3d";
    };
    class UKSFTA_Impact_PStone: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\PStone.p3d";
    };
    class UKSFTA_Impact_Pspark: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Pspark.p3d";
    };
    class UKSFTA_Impact_Smoke_03: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Smoke_03.p3d";
    };
    class UKSFTA_Impact_SparksBall: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\SparksBall.p3d";
    };
    class UKSFTA_Impact_SparksEffect: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\SparksEffect.p3d";
    };
    class UKSFTA_Impact_SparksEffectMulti: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\SparksEffectMulti.p3d";
    };
    class UKSFTA_Impact_Sparks_Big: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Sparks_Big.p3d";
    };
    class UKSFTA_Impact_Sticks: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Sticks.p3d";
    };
    class UKSFTA_Impact_Sticks_Green: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Sticks_Green.p3d";
    };
    class UKSFTA_Impact_StoneSmall: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\StoneSmall.p3d";
    };
    class UKSFTA_Impact_TreePart: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\TreePart.p3d";
    };
    class UKSFTA_Impact_UnderWaterSmoke: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\UnderWaterSmoke.p3d";
    };
    class UKSFTA_Impact_UniversalOnSurface: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\UniversalOnSurface.p3d";
    };
    class UKSFTA_Impact_Universal_02: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\Universal_02.p3d";
    };
    class UKSFTA_Impact_WallPart: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WallPart.p3d";
    };
    class UKSFTA_Impact_WallPart2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WallPart2.p3d";
    };
    class UKSFTA_Impact_WeelEffect: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WeelEffect.p3d";
    };
    class UKSFTA_Impact_WheelEffect: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WheelEffect.p3d";
    };
    class UKSFTA_Impact_WoodChippings: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WoodChippings.p3d";
    };
    class UKSFTA_Impact_WoodParts_01: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WoodParts_01.p3d";
    };
    class UKSFTA_Impact_WoodParts_02: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WoodParts_02.p3d";
    };
    class UKSFTA_Impact_WoodParts_03: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WoodParts_03.p3d";
    };
    class UKSFTA_Impact_WoodParts_04: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\WoodParts_04.p3d";
    };
    class UKSFTA_Impact_bleed_1: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\bleed_1.p3d";
    };
    class UKSFTA_Impact_bleed_2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\bleed_2.p3d";
    };
    class UKSFTA_Impact_coal: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\coal.p3d";
    };
    class UKSFTA_Impact_dir: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\dir.p3d";
    };
    class UKSFTA_Impact_flare: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\flare.p3d";
    };
    class UKSFTA_Impact_rocketsparks: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\rocketsparks.p3d";
    };
    class UKSFTA_Impact_shard: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\shard.p3d";
    };
    class UKSFTA_Impact_shard2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\shard2.p3d";
    };
    class UKSFTA_Impact_shard3: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\shard3.p3d";
    };
    class UKSFTA_Impact_shard4: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\shard4.p3d";
    };
    class UKSFTA_Impact_smoke: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\smoke.p3d";
    };
    class UKSFTA_Impact_smoke_01: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\smoke_01.p3d";
    };
    class UKSFTA_Impact_smoke_02: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\smoke_02.p3d";
    };
    class UKSFTA_Impact_stones: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\stones.p3d";
    };
    class UKSFTA_Impact_test_Arrow: Thing {
        scope = 1;
        model = "\z\uksfta\addons\environment\models\impact\test_Arrow.p3d";
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
            tonemapMethod = 1; // ACE
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
        particleShape = "\z\uksfta\addons\environment\models\impact\Explosion_01.p3d";
        lifeTime = 5;
        size[] = {5, 10, 15};
        color[] = {{0.1, 0.1, 0.1, 0.8}, {0.05, 0.05, 0.05, 0.4}, {0, 0, 0, 0}};
    };
    class UKSFTA_GroundImpact: Default {
        interval = 0.005;
        particleShape = "\z\uksfta\addons\environment\models\impact\Dirt.p3d";
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
