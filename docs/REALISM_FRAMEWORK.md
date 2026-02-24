# UKSFTA Realism Framework - Technical Specification

## 1. Sovereign Accumulation Engine (Phase 7)
The environment engine utilizes a high-performance procedural UI-to-Texture layering system to simulate environmental impact on personnel and equipment.

### 1.1 Dynamic Texture Layering
Instead of static class-based compatibility, the engine uses the `ui(...)` procedural texture method to overlay effects directly onto any uniform or backpack.
- **Wetness**: Darkens textures and adds a "sheen" based on rain intensity and immersion.
- **Snow**: Gradually whitens equipment during Arctic blizzards.
- **Mud**: Cackes equipment based on stance (Prone/Crouch) and surface moisture.
- **Blood**: Dynamic splatter linked directly to ACE3 medical bleeding rates.
- **High-Fidelity Gore**: Integrated pixel-perfect splatter textures (from BloodLust source) with randomized rotation and selection per-unit to ensure no two injury patterns look identical.
- **Burns**: Visual charring from nearby explosions or fires.

### 1.2 Contextual Mud Logic
Mud accumulation is physically governed by moisture availability. 
- In **Arid** or **Temperate** biomes, mud will only accumulate on dirt/grass surfaces if it is actively raining or the unit is already wet.
- Naturally muddy surfaces (swamps/marshes) will always cause accumulation regardless of weather.
- Drying rates are biome-dependent; mud "flakes off" significantly faster in **Arid** zones.

## 2. Advanced Stealth & Camouflage (Phase 8)
The stealth engine has been upgraded from static keyword-based checks to a pixel-perfect terrain sampling model.

### 2.1 Color Similarity Sampling
The engine samples the average RGB values of the player's current visual state (including all accumulation layers) and compares them against the underlying terrain texture.
- **Dynamic Matching**: An MTP uniform covered in snow will provide a high camouflage rating on an Arctic map.
- **Sinusoidal Scaling**: Detection coefficients are scaled using a sinusoidal model to ensure realistic AI spotting distances.

### 2.2 Environmental Obscuration
- **Aerosol Density**: Fog and heavy rain provide up to 40% reduction in AI visibility.
- **Night Compensation**: AI detection ranges are dynamically scaled based on ambient and dynamic lighting at the unit's position.

## 3. Physiological Sync
- **Stamina & Fatigue**: Extreme temperatures (Arid/Arctic) directly scale the `ace_advanced_fatigue_performanceFactor`.
- **Respiratory Visuals**: Cold breath particles are procedurally spawned based on local temperature and respiratory rate, visible in both first and third person.

---
*UKSFTA Strategic Engineering - 2026*
