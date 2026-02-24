class RscPicture;
class UKSFTA_Accumulation_Display {
    idd = -1;
    movingEnable = 0;
    enableSimulation = 1;
    fadein = 0;
    fadeout = 0;
    duration = 1e+011;
    onLoad = "_this call uksfta_environment_fnc_initAccumulationUI;";

    class Controls {
        class Base: RscPicture {
            idc = 100;
            x = 0; y = 0; w = 1; h = 1;
            text = "";
        };
        class Wetness: RscPicture {
            idc = 101;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\wet_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Snow: RscPicture {
            idc = 102;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\snow_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Mud: RscPicture {
            idc = 103;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\mud_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Blood: RscPicture {
            idc = 104;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\blood_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class BloodSplatter: RscPicture {
            idc = 107;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\blood_splat_1.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Burn_Stage1: RscPicture {
            idc = 109;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\burn_char_1.paa";
            colorText[] = {0.4, 0.2, 0.1, 0}; // Singe/Stage 1
        };
        class Burn_Stage2: RscPicture {
            idc = 110;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\burn_char_2.paa";
            colorText[] = {0.2, 0.1, 0.1, 0}; // Charred/Stage 2
        };
        class Burn_Stage3: RscPicture {
            idc = 105;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\burn_char_1.paa";
            colorText[] = {1, 1, 1, 0}; // Extreme/Stage 3
        };
        class Snowfall: RscPicture {
            idc = 106;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\snowfall_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Ash: RscPicture {
            idc = 108;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\snow_ca.paa";
            colorText[] = {0.2, 0.2, 0.2, 0};
        };
        class Chemical: RscPicture {
            idc = 111;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\blood_splat_1.paa";
            colorText[] = {0.2, 0.8, 0.2, 0}; // Green chemical tint
        };
    };
};
