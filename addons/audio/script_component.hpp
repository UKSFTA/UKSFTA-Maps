#ifndef UKSFTA_AUDIO_COMPONENT
#define UKSFTA_AUDIO_COMPONENT

#ifdef COMPONENT
    #undef COMPONENT
#endif
#define COMPONENT audio
#define COMPONENT_BEAUTIFIED Audio
#define PREFIX uksfta

#include "script_version.hpp"
#include "..\main\script_component.hpp"

#undef ADDON
#define ADDON uksfta_audio
#undef ADDON_NAME
#define ADDON_NAME UKSFTA Audio

#endif

