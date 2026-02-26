# UKSFTA Realism Framework - Feature Documentation

## 1. Atmospheric Simulation (ISA)
The framework replaces standard weather with a physics-driven engine.
- **Micro-Climates**: High-altitude areas (+500m) feature colder temperatures and double snow accumulation rates.
- **Wind-Chill**: Effective temperature drops based on wind speed and player exposure, affecting health and stamina.
- **Transonic Ballistics**: Bullets experience random deflection when entering the transonic range (300-360m/s).

## 2. UI2Texture Accumulation
Personnel uniforms dynamically react to the environment in real-time.
- **Wetness**: Progression from dry to soaked based on rain and swimming.
- **Mud**: Prone movement on soft ground causes mud build-up. Mud acts as a natural camouflage modifier.
- **Snow**: Rapid white-out of gear during blizzards.
- **Blood**: ACE3 bleeding triggers localized blood splatter textures.
- **Ash**: Global accumulation during volcanic or nuclear scenarios.

## 3. Physicality & Driving
- **Engine Cool-Down**: Land vehicles emit realistic metal "tink" sounds after shutdown as the engine block contracts.
- **Surface Torque**: Vehicles lose up to 50% engine power in soft ground (Mud/Sand/Snow).
- **Weapon Reliability**: High mud accumulation increases weapon jam probability (ACE compatible).
- **Icy Footing**: Units experience reduced traction and subtle sliding on frozen Arctic surfaces.

## 4. Stealth & Camouflage
- **DAGGER Parity**: Implemented an elite 0.1 baseline camouflage cap for specialized gear.
- **Environment Interaction**: Concealment levels are dynamically adjusted by the unit's accumulation state (e.g., mud improves camo in forests).

## 5. Medical & Audio
- **KAT Synergy**: High humidity triggers KAT Asthma events; combat stress pushes Respiratory Rates.
- **Acoustic Ducking**: Ambient environment sounds are reduced by 60-80% when indoors or inside armored vehicles.
- **Layered Alarms**: Urban combat triggers urban facility sirens and rhythmic civil car alarms.

---
*UKSFTA Framework Reference - Production Release*
