/**
 * UKSFTA Core - PreInit
 */

diag_log text "[UKSF TASKFORCE ALPHA] <INFO> [CORE]: Technical Infrastructure Initialized.";

// --- ESTABLISH GLOBAL STATUS ---
if (isNil "UKSFTA_Environment_Biome") then {
    UKSFTA_Environment_Biome = "PENDING";
    publicVariable "UKSFTA_Environment_Biome";
};

true
