/**
 * UKSFTA Environment - Solar Altitude Utility
 * Returns the approximate sun elevation in degrees (-90 to 90).
 */

// Safe hook for headless testing, defaults to engine dayTime
private _time = missionNamespace getVariable ["uksfta_test_mock_dayTime", dayTime];
private _elevation = 0;

_elevation = sin ((_time - 6) * 15) * 90;

_elevation
