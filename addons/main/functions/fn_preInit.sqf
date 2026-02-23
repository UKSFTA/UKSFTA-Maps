/**
 * UKSFTA Core - PreInit
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CORE]: Technical Infrastructure Initialized.";

// --- ESTABLISH GLOBAL STATUS ---
if (isNil "UKSFTA_Environment_Biome") then {
    missionNamespace setVariable ["UKSFTA_Environment_Biome", "PENDING", true];
};

true
