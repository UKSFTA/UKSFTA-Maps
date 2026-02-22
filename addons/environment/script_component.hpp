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
// RPT Audit Fix: Engine requires String constants ("noise", "grain") for thermal params.
#define UKSFTA_SET_TI(typeStr, val) setTIParameter [typeStr, val]
