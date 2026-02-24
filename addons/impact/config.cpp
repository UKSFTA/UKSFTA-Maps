class CfgPatches {
    class uksfta_impact {
        name = "UKSFTA Impact";
        author = "UKSF Taskforce Alpha Team";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"uksfta_main", "uksfta_environment"};
    };
};

class CfgFunctions {
    class uksfta_impact {
        tag = "uksfta_impact";
        class functions {
            file = "z\uksfta\addons\impact\functions";
            class handleHit {};
        };
    };
};

class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class EventHandlers {
            class UKSFTA_Impact_Handler {
                handleDamage = "_this call uksfta_impact_fnc_handleHit; _this select 2";
            };
        };
    };
    // Gib Models
    class Thing;
    class UKSFTA_Gib_BloodSplatter_LeftHand: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftHand.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftHand_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_LeftLowerArm: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftLowerArm.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftLowerArm_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_LeftLowerLegAndFoot: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftLowerLegAndFoot.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftLowerLegAndFoot_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_LeftUpperArm: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftUpperArm.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftUpperArm_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_LeftUpperLeg: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftUpperLeg.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_LeftUpperLeg_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightFoot: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightFoot.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightFoot_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightHand: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightHand.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightHand_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightIndexFinger: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightIndexFinger.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightIndexFinger_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightLowerArm: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightLowerArm.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightLowerArm_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightLowerLeg: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightLowerLeg.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightLowerLeg_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightMiddleFinger: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightMiddleFinger.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightMiddleFinger_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightPinkyFinger: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightPinkyFinger.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightPinkyFinger_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightRingFinger: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightRingFinger.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightRingFinger_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightThumb: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightThumb.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightThumb_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightUpperArm: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightUpperArm.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightUpperArm_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_RightUpperLeg: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_RightUpperLeg.p3d";
        hiddenSelections[] = {"camo"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_RightUpperLeg_CO.paa"};
    };
    class UKSFTA_Gib_BloodSplatter_Torso: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\BloodSplatter_Torso.p3d";
        hiddenSelections[] = {"camo", "bones", "brains", "eye", "gore", "guts", "pelvis"};
        hiddenSelectionTextures[] = {"z\uksfta\addons\impact\models\gibs\BloodSplatter_Torso_CO.paa", "z\uksfta\addons\impact\models\gibs\bones2.paa", "z\uksfta\addons\impact\models\gibs\brains2.paa", "z\uksfta\addons\impact\models\gibs\eye3554333.paa", "z\uksfta\addons\impact\models\gibs\gore.paa", "z\uksfta\addons\impact\models\gibs\guts11121.paa", "z\uksfta\addons\impact\models\gibs\BloodSplatter_Pelvis_CO.paa"};
    };
    class UKSFTA_Gib_brain_Half: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\brain_Half.p3d";
    };
    class UKSFTA_Gib_brain_Half2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\brain_Half2.p3d";
    };
    class UKSFTA_Gib_brain_splattered2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\brain_splattered2.p3d";
    };
    class UKSFTA_Gib_brain_splattered3: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\brain_splattered3.p3d";
    };
    class UKSFTA_Gib_eye_gib: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\eye_gib.p3d";
    };
    class UKSFTA_Gib_gutrope: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\gutrope.p3d";
    };
    class UKSFTA_Gib_half_skull: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\half_skull.p3d";
    };
    class UKSFTA_Gib_jaw_gib: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\jaw_gib.p3d";
    };
    class UKSFTA_Gib_skull_chunk2: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\skull_chunk2.p3d";
    };
    class UKSFTA_Gib_skull_chunk3: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\skull_chunk3.p3d";
    };
    class UKSFTA_Gib_whole_brain: Thing {
        scope = 1;
        model = "\z\uksfta\addons\impact\models\gibs\whole_brain.p3d";
    };
};
