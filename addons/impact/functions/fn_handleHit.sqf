#include "..\script_component.hpp"
/**
 * UKSFTA Impact - Sovereign Impact Engine (Phase 13)
 * Procedural hit reactions, kinetic ragdolling, and headgear destruction.
 */

params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

if (!local _unit || !alive _unit) exitWith {};

// --- 1. KINETIC ENERGY RAGDOLL (Impact Integration) ---
// Trigger ragdoll if kinetic energy exceeds threshold
private _vel = velocity _unit;
private _speed = vectorMagnitude _vel;
private _caliber = getNumber (configFile >> "CfgAmmo" >> _projectile >> "caliber");

if (_damage > 0.4 || _caliber > 2) then {
    // Probabilistic knockdown based on damage and caliber
    if (random 1.0 < (_damage * (_caliber min 2))) then {
        [_unit] spawn {
            params ["_target"];
            
            // --- BODY THUMP (Surface-Aware) ---
            private _surface = toLower (surfaceType (getPos _target));
            private _sound = "A3\Sounds_F\characters\footsteps\grass\grass_run_01.wss"; // Default
            
            switch (true) do {
                case (_surface find "concrete" != -1 || _surface find "stone" != -1): {
                    _sound = "A3\Sounds_F\characters\footsteps\concrete\concrete_run_01.wss";
                };
                case (_surface find "wood" != -1): {
                    _sound = "A3\Sounds_F\characters\footsteps\wood\wood_run_01.wss";
                };
            };
            playSound3D [_sound, _target, false, getPosASL _target, 2, 0.7, 30];

            _target setUnconscious true;
            sleep (1 + random 3);
            if (alive _target) then { _target setUnconscious false; };
        };
    };
};

// --- 2. HEADGEAR DESTRUCTION (Goko Integration) ---
if (_selection == "head" && _damage > 0.8) then {
    private _headgear = headgear _unit;
    if (_headgear != "") then {
        private _armor = getNumber (configFile >> "CfgWeapons" >> _headgear >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor");
        
        // Caliber penetration vs Armor
        if (_caliber * 10 > _armor) then {
            removeHeadgear _unit;
            // Visual feedback handled by CfgCloudlets overrides
            playSound3D ["A3\Sounds_F\weapons\Closure\soft_revolve_01.wss", _unit, false, getPosASL _unit, 2, 1, 50];

            // Spawn Skull Chunks
            private _skull = "#particlesource" createVehicleLocal (getPosATL _unit);
            _skull setParticleClass "UKSFTA_SkullChunks";
            _skull attachTo [_unit, [0,0,0], "head"];
            [_skull] spawn { sleep 0.1; deleteVehicle (_this select 0); };
        };
    };
};

// --- 3. IMPACT FEEDBACK ---
if (_damage > 0.3) then {
    // Spawn Skull Chunks on headshots
    if (_selection == "head") then {
        private _skull = "#particlesource" createVehicleLocal (getPosATL _unit);
        _skull setParticleClass "UKSFTA_SkullChunks";
        _skull attachTo [_unit, [0,0,0], "head"];
        [_skull] spawn { sleep 0.1; deleteVehicle (_this select 0); };
    };

    // Spawn Meat Gibs on torso for heavy impact
    if (_damage > 0.6) then {
        private _meat = "#particlesource" createVehicleLocal (getPosATL _unit);
        _meat setParticleClass "UKSFTA_MeatGibs";
        _meat attachTo [_unit, [0,0,0], "spine3"];
        [_meat] spawn { sleep 0.1; deleteVehicle (_this select 0); };
    };
};

// --- 4. GORE ACCUMULATION (Sovereign Sync) ---
if (_damage > 0.1) then {
    private _blood = _unit getVariable ["UKSFTA_Accum_Blood", 0];
    _unit setVariable ["UKSFTA_Accum_Blood", (_blood + (_damage * 0.2)) min 1.0, true];
};

true
