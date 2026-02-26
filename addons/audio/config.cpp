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
            class handleArtilleryWhistle {};
            class handleAmbientSoundscapes {};
            class handleDistanceAttenuation {};
            class handlePhysiology {};
            class handleDoppler {};
            class handleFootsteps {};
            class handleObstruction {};
            class handleWorldAlarms {};
            class handleBulletImpacts {};
            class spawnSpotterSplash {};
        };
    };
};

class Extended_PostInit_EventHandlers {
    class uksfta_audio_init {
        init = "call uksfta_audio_fnc_handleSonicCracks; call uksfta_audio_fnc_handleWeaponTails; [] spawn uksfta_audio_fnc_handleFoley; [] spawn uksfta_audio_fnc_handleArtilleryWhistle; [] spawn uksfta_audio_fnc_handleAmbientSoundscapes; [] spawn uksfta_audio_fnc_handlePhysiology; [] spawn uksfta_audio_fnc_handleDoppler; [] spawn uksfta_audio_fnc_handleFootsteps; [] spawn uksfta_audio_fnc_handleWorldAlarms; [] spawn uksfta_audio_fnc_handleBulletImpacts;";
    };
};

class CfgSounds {
    class uksfta_bullet_hit_1 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_1.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_2 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_2.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_3 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_3.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_4 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_4.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_5 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_5.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_6 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_6.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_7 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_7.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_bullet_hit_8 {
        sound[] = {"z\uksfta\addons\audio\sounds\impact\bullet_hit_8.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_physiology_breath {
        sound[] = {"z\uksfta\addons\audio\sounds\physiology\breath.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_physiology_Neckshot {
        sound[] = {"z\uksfta\addons\audio\sounds\physiology\Neckshot.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_physiology_Underwater_Death {
        sound[] = {"z\uksfta\addons\audio\sounds\physiology\Underwater_Death.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_world_Burglar_Alarm {
        sound[] = {"z\uksfta\addons\audio\sounds\world\Burglar_Alarm.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_world_Car_Alarm1 {
        sound[] = {"z\uksfta\addons\audio\sounds\world\Car_Alarm1.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_world_Car_Alarm {
        sound[] = {"z\uksfta\addons\audio\sounds\world\Car_Alarm.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_world_Facility_Alarm {
        sound[] = {"z\uksfta\addons\audio\sounds\world\Facility_Alarm.ogg", 1, 1};
        titles[] = {};
    };
    class uksfta_world_Siren_Alarm_1 {
        sound[] = {"z\uksfta\addons\audio\sounds\world\Siren_Alarm_1.ogg", 1, 1};
        titles[] = {};
    };
};
