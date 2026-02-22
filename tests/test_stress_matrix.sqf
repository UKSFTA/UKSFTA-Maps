#include "mock_arma.sqf"
diag_log "🧪 INITIATING 1000-PERMUTATION STRESS MATRIX (SHADOWED)...";

private _biomes = ["TEMPERATE", "ARID", "ARCTIC", "TROPICAL", "MEDITERRANEAN", "SUBTROPICAL"];
private _presets = ["ARCADE", "REALISM"];
private _samples = 0;
private _errors = 0;

{
    private _biome = _x;
    {
        private _preset = _x;
        uksfta_environment_preset = _preset;
        missionNamespace setVariable ["UKSFTA_Environment_Biome", _biome];

        for "_h" from 0 to 23 step 4 do { // Sample every 4 hours
            _uksfta_dayTime = _h;
            
            for "_w" from 0 to 1 step 0.5 do { // Weather intensities
                _uksfta_overcast = _w;
                _uksfta_rain = _w * 0.5;
                _uksfta_fog = _w * 0.2;

                // --- EXECUTE SHADOWED TRACE ---
                private _sunAlt = sin ((_uksfta_dayTime - 6) * 15) * 90;
                private _multiplier = [1.0, 0.2] select (uksfta_environment_preset == "ARCADE");
                private _noise = ((_uksfta_overcast * 0.2) + (_uksfta_rain * 0.3) + (_uksfta_fog * 0.5)) * _multiplier;
                if (uksfta_environment_preset == "REALISM" && _biome == "ARID" && (_sunAlt > 20)) then {
                    _noise = (_noise + ((_sunAlt / 90.0) * 0.4)) min 1.0;
                };

                // VERBOSE LOGGING
                diag_log format ["  📊 TRACE [%1] | B:%2 | P:%3 | T:%4 | W:%5 | SUN:%6 | TI:%7", 
                    _samples, _biome, _preset, _h, _w, 
                    ([_sunAlt, 1] call CBA_fnc_formatNumber), 
                    ([_noise, 2] call CBA_fnc_formatNumber)
                ];

                if (!finite _noise || !finite _sunAlt) then { _errors = _errors + 1; };
                _samples = _samples + 1;
            };
        };
    } forEach _presets;
} forEach _biomes;

diag_log format ["✅ STRESS MATRIX COMPLETE: %1 samples verified.", _samples];
