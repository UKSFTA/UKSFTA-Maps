#include "..\script_component.hpp"
/**
 * UKSFTA Environment - Sun Elevation Calculator
 * Returns the relative altitude of the sun for temperature curves.
 */

// Pure mathematical utility - allow execution on any machine
// but ensure missionNamespace is accessible.
if (isNil "missionNamespace") exitWith { 0 };

private _dayTime = dayTime;
private _sunAlt = sin ((_dayTime - 6) * 15) * 90;

_sunAlt
