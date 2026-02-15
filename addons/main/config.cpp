#include "script_version.hpp"

#define QUOTE(var) #var

class CfgPatches {
    class UKSFTA_Maps_Main {
        name = "UKSF Taskforce Alpha Maps - Main";
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {};
        author = "UKSF Taskforce Alpha Team";
        authors[] = {"UKSF Taskforce Alpha Team"};
        version = QUOTE(MAJOR.MINOR.PATCHLVL);
        versionStr = QUOTE(MAJOR.MINOR.PATCHLVL);
        versionAr[] = {MAJOR,MINOR,PATCHLVL};
    };
};

class CfgMods {
    author = "UKSF Taskforce Alpha Team";
    logo = "z\z\z\uksfta\addons\maps\addons\maps\addons\main\data\icon_128_ca.paa";
    logoOver = "z\z\z\uksfta\addons\maps\addons\maps\addons\main\data\icon_128_highlight_ca.paa";
    logoSmall = "z\z\z\uksfta\addons\maps\addons\maps\addons\main\data\icon_64_ca.paa";
    name = "UKSF Taskforce Alpha Maps";
    overview = "UKSF Taskforce Alpha";
    picture = "z\z\z\uksfta\addons\maps\addons\maps\addons\main\data\title_co.paa";
    tooltip = "UKSFTA";
    tooltipOwned = "UKSF Taskforce Alpha";
};
