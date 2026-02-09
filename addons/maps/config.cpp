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
    logo = "z\uksfta\maps\data\icon_128_ca.paa";
    logoOver = "z\uksfta\maps\data\icon_128_highlight_ca.paa";
    logoSmall = "z\uksfta\maps\data\icon_64_ca.paa";
    name = "UKSF Taskforce Alpha Maps";
    overview = "UKSF Taskforce Alpha";
    picture = "z\uksfta\maps\data\title_co.paa";
    tooltip = "UKSFTA";
    tooltipOwned = "UKSF Taskforce Alpha";
};
