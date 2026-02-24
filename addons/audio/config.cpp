class CfgPatches {
    class uksfta_audio {
        name = "UKSFTA Audio";
        author = "UKSF Taskforce Alpha Team";
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.14;
        requiredAddons[] = {"uksfta_main", "uksfta_environment"};
    };
};

class CfgFunctions {
    class uksfta_audio {
        tag = "uksfta_audio";
        class functions {
            file = "z\uksfta\addons\audio\functions";
            class preInit { preInit = 1; };
            class handleSonicCracks {};
            class handleWeaponTails {};
            class handleFoley {};
        };
    };
};

class Extended_PostInit_EventHandlers {
    class uksfta_audio_init {
        init = "call uksfta_audio_fnc_handleSonicCracks; call uksfta_audio_fnc_handleWeaponTails; [] spawn uksfta_audio_fnc_handleFoley;";
    };
};
