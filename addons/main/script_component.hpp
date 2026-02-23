#define COMPONENT main
#define COMPONENT_BEAUTIFIED Core
#define PREFIX uksfta

#include "script_version.hpp"

#define QUOTE(var) #var
#define QQUOTE(var) QUOTE(var)

#define ADDON uksfta_main
#define ADDON_NAME UKSFTA Main

// --- VERSIONING ---
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}

// --- PROFESSIONAL BRANDED LOGGING ---
#define UKSFTA_LOG(level,msg) diag_log text (format ["[UKSF TASKFORCE ALPHA] <%1> [%2]: %3", level, QUOTE(COMPONENT_BEAUTIFIED), msg])

#define LOG_ERROR(msg) UKSFTA_LOG("ERROR",msg)
#define LOG_INFO(msg) UKSFTA_LOG("INFO",msg)
#define LOG_TRACE(msg) if ((missionNamespace getVariable ["uksfta_environment_logLevel", 0]) > 1) then { UKSFTA_LOG("TRACE",msg) }
