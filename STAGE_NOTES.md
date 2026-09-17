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

## Stage 2 — System Liquid Glass before Custom Liquid Glass

### 📋 What It's About
Understanding that most UI problems are solved by appropriate system components before resorting to custom Liquid Glass. Stage 2 builds a realistic application using `NavigationStack`, `TabView`, `Toolbar`, `Form`, and `List`, then contrasts it with a custom floating palette approach. The goal is to demonstrate that **system components already solve hierarchy, styling, safe areas, accessibility, and rotation—for free.**

### 🧠 Mental Model

```
SYSTEM COMPONENTS                   CUSTOM FLOATING GLASS
┌──────────────────────────┐        ┌──────────────────────────┐
│ • NavigationStack        │        │ • You control everything │
│ • TabView                │        │ • You manage layout      │
│ • Toolbar                │        │ • You handle safe areas  │
│ • Form / List            │        │ • You respond to events  │
│ • Sheets / Alerts        │        │ • You style manually     │
├──────────────────────────┤        ├──────────────────────────┤
│ ✅ Automatic styling     │        │ ❌ Manual styling        │
│ ✅ Safe area handling    │        │ ❌ Safe area bugs        │
│ ✅ Rotation support      │        │ ❌ Rotation issues       │
│ ✅ Accessibility         │        │ ❌ Accessibility gaps    │
│ ✅ Tested patterns       │        │ ❌ Unproven patterns     │
│ ✅ OS-aware behavior     │        │ ❌ You reinvent wheels   │
└──────────────────────────┘        └──────────────────────────┘
      ✅ START HERE                    ⚠️ ONLY IF NEEDED
```

**Key principle:** System components are free solutions. Custom glass adds cost (code, testing, maintenance, accessibility). Only use custom glass when system components don't fit the interaction model.

### 🎯 Key Takeaway

**Adopt system design first; create custom glass only when genuinely required.**

Before building a custom floating control palette, ask:

> **Can I solve this with `NavigationStack`, `Toolbar`, `TabView`, `Menu`, or `Sheet`?**

If yes, use the system component. If no (e.g., "I need immersive floating actions that morph based on content beneath"), then custom glass is justified.

**Examples:**
- **Primary navigation?** → `NavigationStack` (system, tested)
- **Tab-based organization?** → `TabView` (system, tested)
- **Toolbar actions?** → `Toolbar` (system, automatic safe area)
- **Context menu?** → `Menu` or `.contextMenu` (system, adaptive)
- **Unique interaction model?** → Custom glass (justified)

**The test:** Toggle between system and custom floating in Stage 2. On rotation, check safe areas. Tap actions and verify touch targets. Compare accessibility. The system version requires almost zero work; the custom version requires you to solve every problem again.

---

## Stage 3 — First Custom Glass Effect

### 📋 What It's About
Introduction to the `glassEffect()` API (iOS 18+) and understanding how it differs from `Material`. Stage 3 compares static material backgrounds with contextual glass rendering. The goal is to observe that `glassEffect()` is more sophisticated: it adapts to content beneath it, responds to light/dark, and feels integrated rather than "pasted on."

### 🧠 Mental Model

```
MATERIAL.THIN                       GLASSEFFECT()
┌──────────────────────────┐        ┌──────────────────────────┐
│ Static blur + opacity    │        │ Contextual rendering     │
├──────────────────────────┤        ├──────────────────────────┤
│ • Fixed appearance       │        │ • Adapts to content      │
│ • Same on all backgrounds│        │ • Light-aware            │
│ • Simple to render       │        │ • Interaction-aware      │
│ • Predictable           │        │ • More sophisticated     │
│ • Feels separate        │        │ • Feels integrated       │
└──────────────────────────┘        └──────────────────────────┘
      ✅ Works                            ⭐ Better
```

**Key insight:** `glassEffect()` = Material + contextual awareness. It's not just blur; it's responsive rendering.

### 🎯 Key Takeaway

**`glassEffect()` is contextual; `Material` is static.**

`Material.thin` is a safe baseline that works everywhere. It's blur + opacity, always the same.

`glassEffect()` is smarter. It responds to:
- Content beneath (adapts to colors/patterns)
- Light/dark appearance (automatic semantic color)
- Interaction state (visual feedback on press)
- Environment (Reduce Transparency, etc.)

When testing Stage 3:
- On a vibrant gradient: `glassEffect()` should feel more integrated
- On a busy pattern: `glassEffect()` should maintain better legibility
- On interaction: `glassEffect()` should provide better visual feedback

**When to use which:**
- Need a simple frosted surface? → `Material.thin`
- Building an immersive control? → `glassEffect()`
- Unsure? → Start with `Material`, upgrade to `glassEffect()` if it looks wrong

**iOS 17 fallback:** If targeting iOS 17, use `Material` as fallback. iOS 18+ can upgrade to `glassEffect()` with `@available` guards.

---
