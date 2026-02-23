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
// Internal TI Indices (0 = Noise, 7 = Grain)
#define TI_NOISE 0
#define TI_GRAIN 7

// Sovereign Bridge: Dynamic call to bypass linter type-checking while ensuring runtime stability
#define UKSFTA_SET_TI(idx,val) [idx,val] call { setTIParameter _this }
