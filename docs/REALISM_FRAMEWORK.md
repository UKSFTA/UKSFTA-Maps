# UKSFTA Realism Framework - Technical Manual

## 1. Overview

The UKSFTA Realism Framework is a modular, high-fidelity environmental and physical simulation suite designed to provide a consistent tactical experience across all unit operations. It is 100% map-agnostic and utilizes heuristic analysis to adapt to any terrain in the Arma 3 ecosystem.

## 2. Universal Environment Engine

### Heuristic Biome Detection

The engine "interrogates" the loaded map at runtime using three layers of intelligence:

1.  **Latitude Audit**: Automatically detects Arctic or Tropical conditions based on geographic metadata.
2.  **Vegetation Analysis**: Scans map clutter for keywords (e.g., "palm", "sand", "snow") to identify the physical environment.
3.  **Regional Keywords**: Fallback detection for known unit theatres (e.g., `zagor`, `dagger`).

### Dynamic Weather State Machine

Weather transitions are handled via a logical Markov-Chain matrix:

- **States**: 0 (Clear), 1 (Overcast), 2 (Storm).
- **Transitions**: Controlled 30-60 minute interpolation windows to prevent "weather snaps."
- **Synchronization**: Automatically links wind speed, gusts, and wave height to atmospheric intensity.

### Modular Visual Engine

The UKSFTA framework utilizes a **Modular Visual Engine** that operates independently of terrain configurations (`CfgWorlds`), ensuring 100% fidelity on any map.

- **Dynamic Color Grading**: Utilizes a sovereign Post-Processing stack (Handle 1501) driven by real-time solar elevation and weather extinction.
- **Solar Interpolation**: Automatically shifts RGB balance from warm golden-hour tones to high-contrast night-blue based on physical sun angles.
- **Atmospheric FX**: Integrates local particle-based raindrops and adaptive film grain to provide tactile grit during intense operations.

## 3. Technical Integrations

### ACE3 Ballistics

- Dynamically pushes temperature, humidity, and barometric pressure into the `ace_weather` core.
- Profiles are biome-specific (e.g., Arid: 45°C / 10% Humid; Arctic: -30°C / 80% Humid).

### KAT Medical

- Synchronizes environmental temperature with KAT's core body temperature simulation.
- Impact on stamina and treatment efficiency scales with biome severity.

### TFAR & ACRE2 Comms

- **Signal Degradation**: 20-40% reduction in radio range during severe storms.
- **EMI (Electromagnetic Interference)**: Rare "static bursts" synchronized with engine lightning strikes.

### Aviation Physics

- **Turbulence Engine**: Applies random physical forces to aircraft in heavy clouds/storms.
- **AFM Awareness**: Automatically disables overrides if the Advanced Flight Model or conflicting mods are detected.

## 4. Camouflage & Concealment (Ghost Ops)

- **AI Grass Fix**: 80% visibility reduction when prone in grassy/forested surfaces.
- **Uniform Matching**: 20% bonus for correct camo choice; 50% penalty for mismatch (e.g., dark camo in snow).
- **AI Mod Balancing**: Detects **Lambs Danger** or **VCOM AI** and applies an automated concealment buffer to ensure tactical fairness.

## 5. Tactical Cartography

### Layer Toggling

Operators can switch between visual styles via the CBA Addon Options:

- **STANDARD**: Vanilla or Enhanced Map view.
- **SATELLITE**: High-fidelity overhead imagery.
- **OS_HYBRID**: Professional Ordnance Survey style (Topographic + Satellite).

### Performance Optimization

Uses a viewport-specific renderer that only draws what the operator sees, eliminating map lag common in other overlay mods.

## 6. Configuration & Control

### CBA Addon Options

- **Framework Preset**: Toggle between **ARCADE** (easier play) and **REALISM** (Diamond Standard).
- **Intensity Sliders**: Individual controls for Thermal noise, Turbulence, and Signal loss.
- **Performance Toggles**: Clients can independently disable particles or breath vapor to save FPS.

### Eden Editor

Mission makers can lock settings per-mission via **Attributes -> Map -> UKSFTA Environment**:

- Force a specific Biome.
- Set the Initial Weather State.
- Preview visual effects in real-time within the editor.
