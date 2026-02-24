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
        class Burn: RscPicture {
            idc = 105;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\burn_char_1.paa";
            colorText[] = {1, 1, 1, 0};
        };
        class Snowfall: RscPicture {
            idc = 106;
            x = 0; y = 0; w = 1; h = 1;
            text = "z\uksfta\addons\environment\data\snowfall_ca.paa";
            colorText[] = {1, 1, 1, 0};
        };
    };
};
