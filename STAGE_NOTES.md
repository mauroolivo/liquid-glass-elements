# Liquid Glass Course — Stage Notes

> **Rule:** For every completed stage, document: (1) what the stage is about, (2) the mental model (if applicable), and (3) the key takeaway. This file evolves as new stages are completed.

---

## Stage 0 — Liquid Glass Laboratory

### 📋 What It's About
Foundation and environment setup. Stage 0 establishes a controlled testing environment with 6 visually distinct backgrounds to make glass behavior obvious without applying any Liquid Glass APIs yet. The focus is on understanding why **adaptive materials are better than static overlays**.

### 🧠 Mental Model

```
STATIC OPACITY                          ADAPTIVE MATERIAL
┌─────────────────────────┐            ┌─────────────────────────┐
│ Color.black.opacity(0.5)│            │ Material.thin           │
├─────────────────────────┤            ├─────────────────────────┤
│ • Fixed appearance      │            │ • Responds to system    │
│ • Doesn't adapt         │            │ • Light ↔ Dark aware    │
│ • Illegible on some     │            │ • Respects transparency │
│   backgrounds           │            │   settings              │
│ • Looks "pasted on"     │            │ • Feels integrated      │
└─────────────────────────┘            └─────────────────────────┘
           ❌ WRONG                               ✅ CORRECT
```

**Key insight:** Even without Liquid Glass, the system materials (`Material.thin`, `Material.regular`, etc.) adapt automatically to:
- Light/Dark appearance
- High Contrast mode
- Reduce Transparency accessibility setting
- Dynamic Type sizing

### 🎯 Key Takeaway

**Material always wins over manual opacity.**

Before you build custom Liquid Glass effects, understand that SwiftUI's built-in `Material` types are already doing adaptive work for you. They respond to the environment without extra code. Custom glass effects must match or exceed this adaptiveness—otherwise they fail accessibility tests and look "wrong" on different backgrounds.

**Test this principle:** Switch Stage 0 between the 6 backgrounds. Notice how the Material button remains legible and integrated, while the opaque overlay becomes invisible or clashes with the content.

---
