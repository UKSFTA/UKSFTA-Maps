# UKSFTA Realism Framework - Technical Specification

## 1. Sovereign Accumulation Engine (Phase 7)
The environment engine utilizes a high-performance procedural UI-to-Texture layering system to simulate environmental impact on personnel and equipment.

### 1.1 Dynamic Texture Layering
Instead of static class-based compatibility, the engine uses the `ui(...)` procedural texture method to overlay effects directly onto any uniform or backpack.
- **Wetness**: Darkens textures and adds a "sheen" based on rain intensity and immersion.
- **Snow**: Gradually whitens equipment during Arctic blizzards.
- **Mud**: Cackes equipment based on stance (Prone/Crouch) and surface moisture.
- **Blood**: Dynamic splatter linked directly to ACE3 medical bleeding rates.
- **Chemicals**: Greenish acid/toxic splatter from hazardous sources.
- **Ash**: Dark grey charred dusting from fires or nuclear winter scenarios.
- **5-Stage Granular Burns**: Seamless visual progression from light singeing to total charring.

### 1.2 Contextual Mud & Snow Logic
- **Moisture Dependency**: Mud will only accumulate on dirt/grass surfaces if it is actively raining or the unit is already wet.
- **Thermal Melting**: Proximity to fires or intense heat sources physically melts snow and clears ash from unit gear in real-time.
- **Multiplayer Sync**: Persistence is maintained via an Owner-Authority model, ensuring visual consistency across all clients.

## 2. Master Naturalism & Climate (Phase 10)
Advanced lighting and atmospheric simulation removing the need for external post-processing shaders (ReShade).

### 2.1 Linear Tonemapping (Method 2)
The project utilizes physically accurate Linear Tonemapping with calibrated aperture ranges (0.00001 to 256).
- **High Dynamic Range**: Prevents "blown out" skies while maintaining deep shadow detail.
- **Kelvin-Accurate Grading**: Real-time solar elevation grading shifts color temperature from warm 2500K (sunrise) to natural 6500K (noon).

### 2.2 Shade-Aware Micro-Climates
- **Direct Solar Occlusion**: Real-time `checkVisibility` tracking of the sun vector.
- **Temperature Drop**: Ambient temperature drops by up to 5°C when in occluded/shaded areas (under trees, building shadows, or overhangs).
- **Thermal Object Signatures**: High-fidelity TI signatures applied to flares, tracers, and heated objects via `setTI`.

## 3. Sovereign Ballistics Engine (Phase 11)
Atmospheric-linked ballistics standardization based on real-time climate data.

### 3.1 Dynamic Atmospheric Drag
Projectiles experience variable air resistance based on the calculated **Density Ratio (Rho)**.
- **Cold/Dense Air**: Increased drag in Arctic biomes (+15% standard).
- **Hot/Thin Air**: Reduced drag in Arid biomes (-10% standard).
- **Humidity Scaling**: Moisture content adds a secondary friction modifier to simulate heavy air in storm conditions.

### 3.2 Vehicle Thermo-Signatures
- **Engine Load Dynamics**: TI signatures scale with speed and RPM.
- **Biome-Specific Cooling**: Engines cool 50% faster in Arctic biomes and retain heat significantly longer in Arid zones.
- **Procedural Heat Haze**: Visual and thermal refraction effects attached to active engine exhaust/hulls.

## 4. Advanced Stealth & Camouflage (Phase 8)
- **Pixel-Perfect Sampling**: Average RGB values of the player (including all accumulation layers) are compared against the underlying terrain texture.
- **Sinusoidal Scaling**: Camouflage coefficients are mathematically balanced to ensure realistic AI spotting distances across all biomes.

## 5. Inter-Mod Compatibility Bridge (Phase 16)
The Sovereign Engine actively synchronizes its environmental data with external mod frameworks to ensure a unified realism experience.

### 5.1 ACE3 & KAT Medical
- **Weather Sync**: Pushes Sovereign Temperature and Humidity directly into `ace_weather` variables.
- **Stamina/Stress**: High stress levels (calculated via combat intensity) accelerate ACE3 fatigue and increase KAT respiratory rates.

### 5.2 TFAR & ACRE Support
- **Dynamic Signal Loss**: Atmospheric storms, sandstorms (Arid), and heavy rain trigger real-time signal multiplicators for radio transmissions.

### 5.3 AI Frameworks (LAMBS / VCOM)
- **Environment-Aware AI**: Dynamically scales AI `aimingAccuracy` and `spotDistance` based on visibility (rain/fog) and atmospheric obscuration.
- **Suppression Synergy**: Hit reactions and concussion effects are designed to complement LAMBS behavior trees without overriding their tactical AI.

---
*UKSFTA Strategic Engineering - 2026*
