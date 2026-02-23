#ifndef UKSFTA_CARTOGRAPHY_COMPONENT
#define UKSFTA_CARTOGRAPHY_COMPONENT

#define COMPONENT cartography
#define COMPONENT_BEAUTIFIED Cartography
#define PREFIX uksfta

#include "script_version.hpp"

#ifndef QUOTE
    #define QUOTE(var) #var
#endif
#ifndef QQUOTE
    #define QQUOTE(var) QUOTE(var)
#endif

#define ADDON uksfta_cartography
#define ADDON_NAME UKSFTA Cartography

// --- VERSIONING ---
#define VERSION MAJOR.MINOR.PATCHLVL.BUILD
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL.BUILD)
#define VERSION_AR MAJOR,MINOR,PATCHLVL,BUILD

#define VERSION_CONFIG version = VERSION_STR; versionStr = VERSION_STR; versionAr[] = {VERSION_AR}

#endif
