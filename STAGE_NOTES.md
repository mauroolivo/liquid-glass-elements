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

## Stage 1 — Understand the Liquid Glass Design Language

### 📋 What It's About
Understanding hierarchy and intentional design. Stage 1 contrasts two philosophies: "glass everywhere" (every surface is elevated, hierarchy is noisy) versus "strategic glass" (glass only on controls/navigation, content is clear). The goal is to develop intuition about when glass improves hierarchy and when it merely decorates surfaces.

### 🧠 Mental Model

```
GLASS EVERYWHERE                    STRATEGIC GLASS
┌──────────────────────────┐        ┌──────────────────────────┐
│ • All surfaces elevated  │        │ • Content on plain bg    │
│ • No hierarchy           │        │ • Glass on controls only │
│ • Content blends with    │        │ • Clear visual hierarchy │
│   controls               │        │ • Guides attention       │
│ • Looks noisy            │        │ • Feels organized        │
│ • Hard to find primary   │        │ • Primary action obvious │
│   action                 │        │                          │
└──────────────────────────┘        └──────────────────────────┘
         ❌ FAILS                            ✅ SUCCEEDS
```

**Key principle:** Glass communicates functional elevation. If everything is elevated, nothing is.

### 🎯 Key Takeaway

**Glass is a tool for hierarchy, not decoration.**

Ask this question before adding glass to any element:

> **Why should this element be visually separated from content beneath it?**

If the answer is "it looks cool" or "everything else is glass," the glass is probably wrong. Glass should answer: "because this is a control," "because this navigates," "because this is an action the user needs to find."

Content articles? Plain background.
Footer metadata? Plain background.
Primary action button? Glass.
Secondary action buttons? Maybe glass, but might share a container.

**The test:** Toggle between incorrect and preferred implementations on a busy, vibrant, and light background. Watch where your eye naturally goes. In the incorrect version (glass everywhere), you search for meaning. In the preferred version, hierarchy guides you.

---
