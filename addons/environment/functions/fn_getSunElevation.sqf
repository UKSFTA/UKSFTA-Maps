/**
 * UKSFTA Environment - Solar Altitude Utility
 * Returns the approximate sun elevation in degrees (-90 to 90).
 */

// Simple approximation based on time of day
private _time = dayTime;
private _elevation = 0;

// Shift time so 12:00 is 0
private _offset = _time - 12;

// Map 24h cycle to a Sine wave
// 12:00 (0) -> sin(90) = 1 (Max Elevation)
// 18:00 (6) -> sin(0) = 0 (Horizon)
// 00:00 (-12) -> sin(-90) = -1 (Nadir)
_elevation = (sin ((12 - abs _offset) * 15)) * 90;

_elevation
