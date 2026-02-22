#define COMPONENT environment
#define COMPONENT_BEAUTIFIED Environment
#define PREFIX uksfta

#include "..\environment\script_version.hpp"

#define QUOTE(var) #var
#define QQUOTE(var) QUOTE(var)

#define ADDON uksfta_environment
#define ADDON_NAME UKSFTA Environment

// --- VERSIONING ---
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}

// --- TECHNICAL MACROS ---
// Allows for headless testing by bypassing problematic engine commands
#ifdef UKSFTA_TEST_ENV
    #define UKSFTA_SET_TI(index, value) /* VM Bypass */
#else
    #define UKSFTA_SET_TI(index, value) setTIParameter [index, value]
#endif
