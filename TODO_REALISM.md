# UKSFTA Universal Realism - Tactical Roadmap

Status: **Phase 2 In-Progress**

## ✅ Completed (Integrated)
- **Modular Color Grading**: Detached from static configs; uses solar elevation and weather desaturation.
- **Dynamic Visual Noise**: Adaptive FilmGrain based on sun angle and precipitation.
- **Immersive Rain**: High-fidelity particle effects locally attached to player visor/vicinity.
- **Biome Desaturation**: Specific desaturation logic for Arctic/Arid environments.

## 🚧 Phase 3: Advanced Atmospheric Lighting
- [ ] **Cloud Tinting Engine**: Implement real-time `setCloudColor` shifts to match sunrise/sunset Kelvin values.
- [ ] **Volumetric Fog Refinement**: Integrate `setFog` height/decay interpolation based on biome (e.g., ground fog in temperate woodland).
- [ ] **Advanced Lightning Logic**: Shift from static loop to probabilistic density based on `overcast` intensity.
- [ ] **Lunar Grading**: Adjust RGB/Brightness specifically for Full Moon vs. New Moon scenarios (requires moon phase probe).

## 🔭 Future Inspiration (Reference Mod Audit)
- [ ] **Enoch-Specific Scattering**: Replicate the scattering coefficients from `bp_sw_enoch` for heavy woodland maps.
- [ ] **Thunderbolt Intensity**: Map the reference mod's lightning diffuse/ambient values into our modular engine.
- [ ] **Dynamic Caustics**: Evaluate feasibility of dynamic underwater lighting for tropical maps without terrain config overrides.

---
*Maintained by UKSFTA Strategic Engineering*
