#ifndef PREFIX
    #define PREFIX uksfta
#endif

#ifndef COMPONENT
    #define COMPONENT main
#endif

#include "script_version.hpp"

// --- Standardized Macro Guards ---
#ifndef DOUBLES
    #define DOUBLES(var1,var2) var1##_##var2
#endif

#ifndef QUOTE
    #define QUOTE(var1) #var1
#endif

#ifndef GVAR
    #define GVAR(var1) DOUBLES(PREFIX,var1)
#endif

#ifndef QGVAR
    #define QGVAR(var1) QUOTE(GVAR(var1))
#endif

#ifndef FUNC
    #define FUNC(var1) DOUBLES(DOUBLES(PREFIX,COMPONENT),DOUBLES(fnc,var1))
#endif

#ifndef QFUNC
    #define QFUNC(var1) QUOTE(FUNC(var1))
#endif

#ifndef ADDON
    #define ADDON DOUBLES(PREFIX,COMPONENT)
#endif

// --- Professional Logging Suite ---
#ifndef LOG_LEVEL_ERROR
    #define LOG_LEVEL_ERROR 0
    #define LOG_LEVEL_INFO 1
    #define LOG_LEVEL_TRACE 2
#endif

// Single-argument logging to resolve PE9 parser errors
#ifndef LOG_BASE
    #define LOG_BASE(LEVEL,MSG) [LEVEL,MSG,QUOTE(COMPONENT)] call uksfta_main_fnc_telemetry
    #define LOG(MSG) LOG_BASE("INFO",MSG)
    #define LOG_ERROR(MSG) LOG_BASE("ERROR",MSG)
    #define LOG_WARN(MSG) LOG_BASE("WARN",MSG)
    #define LOG_TRACE(MSG) if (missionNamespace getVariable [QUOTE(GVAR(logLevel)), 1] >= 2) then { ["TRACE",MSG,QUOTE(COMPONENT)] call uksfta_main_fnc_telemetry }
#endif

// --- Internalized Versioning ---
#ifndef VERSION_STR
    #define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
    #define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD
    #define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}
#endif
