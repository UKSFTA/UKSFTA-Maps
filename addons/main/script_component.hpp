#ifndef COMPONENT
    #define COMPONENT main
#endif
#ifndef COMPONENT_BEAUTIFIED
    #define COMPONENT_BEAUTIFIED Core
#endif

#ifndef PREFIX
    #define PREFIX uksfta
#endif

#include "script_version.hpp"

#ifndef QUOTE
    #define QUOTE(var) #var
#endif
#ifndef QQUOTE
    #define QQUOTE(var) QUOTE(var)
#endif

#ifndef ADDON
    #define ADDON uksfta_main
#endif

#ifndef ADDON_NAME
    #define ADDON_NAME UKSFTA Main
#endif

// --- VERSIONING ---
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}
