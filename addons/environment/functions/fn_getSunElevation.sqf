/**
 * UKSFTA Environment - Solar Altitude Utility
 * Returns the approximate sun elevation in degrees (-90 to 90).
 */

// ENGINE WRAPPER: Use _mock_dayTime if defined (for tests), otherwise native dayTime
private _time = if (!isNil "_mock_dayTime") then { _mock_dayTime } else { dayTime };
private _elevation = 0;

_elevation = sin ((_time - 6) * 15) * 90;

_elevation
