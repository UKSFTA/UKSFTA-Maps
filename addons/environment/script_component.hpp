#define COMPONENT environment
#define COMPONENT_BEAUTIFIED Environment
#define PREFIX uksfta

#include "script_version.hpp"

#define VERSION MAJOR.MINOR.PATCHLVL
#define VERSION_STR QUOTE(MAJOR.MINOR.PATCHLVL)
#define VERSION_AR {MAJOR,MINOR,PATCHLVL}

#define VERSION_CONFIG \
    version = VERSION_STR; \
    versionStr = VERSION_STR; \
    versionAr[] = VERSION_AR

#define QUOTE(var) #var
#define QQUOTE(var) QUOTE(var)

#define ADDON uksfta_environment
#define ADDON_NAME UKSFTA Environment
