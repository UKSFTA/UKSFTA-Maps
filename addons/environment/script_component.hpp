#ifndef UKSFTA_ENVIRONMENT_COMPONENT
#define UKSFTA_ENVIRONMENT_COMPONENT

#define COMPONENT environment
#define COMPONENT_BEAUTIFIED Environment
#define PREFIX uksfta

#include "..\environment\script_version.hpp"

#ifndef QUOTE
    #define QUOTE(var) #var
#endif
#ifndef QQUOTE
    #define QQUOTE(var) QUOTE(var)
#endif

#define ADDON uksfta_environment
#define ADDON_NAME UKSFTA Environment

// --- VERSIONING ---
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}

// --- TECHNICAL MACROS ---
#define UKSFTA_SET_TI(idx,val) [idx,val] call { setTIParameter _this }

#endif
