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

## Stage 4 — Glass Shape and Geometry

### What It's About
Stage 4 focuses on geometry discipline: corner radius, padding, spacing rhythm, and size consistency across control types (icon button, text button, segmented actions, large action, badge). It contrasts random geometry (incorrect) with coherent geometry (preferred).

### Mental Model

```text
CONTROL PURPOSE
    -> chooses base shape (circle / capsule / rounded rect)
    -> chooses target size and padding
    -> chooses corner rhythm shared with nearby controls
    -> creates visual family + predictable touch behavior
```

If each control chooses arbitrary radii/padding, the interface feels noisy. If geometry is consistent, controls feel related and intentional.

### Key Takeaway
Use a geometry system, not one-off numbers.

- Icon actions: stable circular targets
- Text actions: capsule or rounded rect with readable padding
- Segments: equal vertical rhythm and related corners
- Prominent actions: larger but same shape language
- Badges: compact corners proportional to size

The visual polish in glass UI is mostly geometry, not extra effects.

---

## Stage 5 - Glass Buttons and Interaction

### What It's About
Stage 5 compares button styles (`plain`, `bordered`, `borderedProminent`, `glass`, `glassProminent`) and evaluates interaction hierarchy across primary, secondary, navigation, and destructive actions. The core exercise is intentionally making every action prominent, then reducing prominence to only what deserves it.

### Mental Model

```text
ACTION IMPORTANCE
    -> choose style weight
    -> choose prominence
    -> choose tint/semantic emphasis
    -> preserve hierarchy
```

If all actions are prominent, users lose signal. Prominence should encode priority, not decoration.

### Key Takeaway
Use `glassProminent` sparingly for true primary intent; keep secondary/navigation actions lighter.

- Primary: often `glassProminent`
- Secondary/navigation: often `glass`
- Destructive: clear semantic tint + restrained prominence
- Over-prominence is a hierarchy bug

Button style is a semantic decision, not only a visual one.

---

## Stage 6 — Interactive custom glass

### 📋 What It's About
Stage 6 separates decorative glass from genuine interaction. It contrasts a control that only looks interactive with a real button that changes state, responds to press, and communicates its purpose clearly. The goal is to understand that visual polish is not enough: the control must behave like a control.

### 🧠 Mental Model

```text
LOOKS LIKE A CONTROL               IS A REAL CONTROL
┌──────────────────────────┐      ┌──────────────────────────┐
│ • Decorative only        │      │ • Button semantics       │
│ • No state change        │      │ • Press feedback         │
│ • No accessibility hint  │      │ • State changes          │
│ • No trust-building      │      │ • Trustworthy behavior   │
└──────────────────────────┘      └──────────────────────────┘
      ❌ APPEARANCE ONLY              ✅ SEMANTICS + APPEARANCE
```

**Key principle:** Interaction semantics matter more than appearance. Glass can make something look important, but only real controls earn the user's trust.

### 🎯 Key Takeaway

**If it looks tappable, it should behave tappable.**

Use decorative glass only when the element is truly passive. If the user can act on it, it should be a `Button`, expose accessibility hints, and give clear press feedback.

**The test:** Compare the decorative glass card with the interactive glass button. Tap the real control and watch the state, label, and press feedback change. The decorative version should remain static, which is exactly why it is not enough for an action.

---

## Stage 7 — Tint, prominence and semantic color

### 📋 What It's About
Stage 7 explores when tint adds meaning and when it becomes visual noise. It compares neutral, tinted, and prominent glass treatments across semantic actions such as play, favorite, confirm, delete, and record. The goal is to learn that glass already gives a control presence; tint should be reserved for meaning, not decoration.

### 🧠 Mental Model

```text
GLASS ALREADY HAS PRESENCE            TINT ADDS MEANING
┌──────────────────────────┐         ┌──────────────────────────┐
│ • Control is visible     │         │ • Role is clearer        │
│ • Shape carries weight   │         │ • Action gets identity   │
│ • No extra color needed  │         │ • Semantic signal added  │
│ • Avoids noise           │         │ • Priority becomes clear │
└──────────────────────────┘         └──────────────────────────┘
        ✅ BASELINE                         ✅ ONLY WHEN HELPFUL
```

**Key principle:** Tint should communicate something specific. If it does not encode role, priority, or state, it may just be noise layered on top of already-present glass.

### 🎯 Key Takeaway

**Use tint sparingly; let glass do the heavy lifting.**

Tint is best when it reinforces semantic meaning:
- Play: primary blue emphasis
- Favorite: accent color for preference
- Confirm: success signal
- Delete: destructive red
- Record: action/attention color

When every control is bright and prominent, hierarchy collapses. The preferred version uses tint selectively so the user can read priority at a glance.

**The test:** Compare the oversaturated version with the selective version on vibrant, dark, and light backgrounds. Notice whether tint improves clarity or distracts from it.

---

## Stage 8 — GlassEffectContainer

### 📋 What It's About
Stage 8 compares nearby glass elements rendered independently versus coordinated inside `GlassEffectContainer`. The goal is to learn when related glass controls should feel like a group instead of three separate floating pieces.

### 🧠 Mental Model

```text
INDEPENDENT GLASS                  COORDINATED GLASS
┌──────────────────────────┐       ┌──────────────────────────┐
│ • Separate surfaces      │       │ • Related surfaces      │
│ • No shared coordination  │       │ • Shared rendering logic │
│ • Weaker grouping signal  │       │ • Stronger grouping      │
│ • Can feel accidental     │       │ • Feels intentional      │
└──────────────────────────┘       └──────────────────────────┘
        ⚠️ SEPARATE                     ✅ ONE VISUAL SYSTEM
```

**Key principle:** `GlassEffectContainer` is about coordination, not decoration. Nearby glass belongs together only when it represents a related control system.

### 🎯 Key Takeaway

**Group related glass; leave unrelated glass alone.**

Use `GlassEffectContainer` when controls are semantically linked and should visually behave like one unit. If the controls are unrelated, keep them separate and let spacing communicate that they are distinct.

**The test:** Compare the independent cluster with the grouped version and adjust spacing. Ask whether the controls feel like one cluster, a toolbar, or just a few floating buttons.

---

## Stage 9 — Glass unions and grouped controls

### 📋 What It's About
Stage 9 explores when multiple related controls should feel like a single visual unit. It compares isolated glass buttons with grouped clusters and asks whether the controls are truly semantically related before merging them.

### 🧠 Mental Model

```text
ISOLATED CONTROLS                  GROUPED CONTROLS
┌──────────────────────────┐       ┌──────────────────────────┐
│ • Separate pieces        │       │ • One coherent cluster  │
│ • No shared identity     │       │ • Shared visual rhythm  │
│ • Clear separation       │       │ • Clear semantic link   │
│ • More fragmentation     │       │ • More cohesive         │
└──────────────────────────┘       └──────────────────────────┘
        ⚠️ APART                          ✅ TOGETHER
```

**Key principle:** Union should reinforce meaning. It is useful when the controls belong to the same task, not when it merely looks stylish.

### 🎯 Key Takeaway

**Group only what belongs together.**

Use union/grouping for compact clusters like media transport or filter controls. Leave unrelated controls separate so hierarchy stays honest and interaction remains obvious.

**The test:** Compare the isolated version with the grouped version for both media and filter controls. Ask whether the union helps the user understand the task faster or just makes the interface look more decorative.

---

## Stage 10 — Morphing and glass identity

### 📋 What It's About
Stage 10 explores expansion and collapse transitions for a compact action menu. It compares a normal SwiftUI transition with a version that gives Liquid Glass stable semantic identity, so the compact trigger and expanded close control can feel like two states of the same element.

### 🧠 Mental Model

```text
STATE SWAP                           SEMANTIC MORPH
┌──────────────────────────┐         ┌──────────────────────────┐
│ • One view disappears    │         │ • One control evolves    │
│ • Another appears        │         │ • Identity is preserved  │
│ • Relationship is weak   │         │ • Relationship is clear  │
│ • Feels more abrupt      │         │ • Feels continuous       │
└──────────────────────────┘         └──────────────────────────┘
        ⚠️ REPLACEMENT                    ✅ CONTINUITY
```

**Key principle:** Morphing should follow semantic identity, not just geometry. If two elements represent the same role across states, give them shared identity.

### 🎯 Key Takeaway

**Preserve identity for controls that keep the same meaning across states.**

In the menu example, the collapsed `+` trigger and the expanded `Close` control are both the menu toggle. They deserve shared identity more than the newly introduced action buttons do.

**The test:** Compare the ordinary transition with the glass-identity version. Ask whether the compact trigger feels like it becomes the close control, or whether the interface simply swaps unrelated elements.

---

## Stage 11 — GlassEffectTransition

### 📋 What It's About
Stage 11 compares ordinary SwiftUI transitions with Liquid Glass-specific transitions. The focus is on how glass appears/disappears and whether transition style improves continuity or adds distraction.

### 🧠 Mental Model

```text
ORDINARY TRANSITION                GLASS TRANSITION
┌──────────────────────────┐       ┌──────────────────────────┐
│ • View enter/exit        │       │ • Glass-aware enter/exit │
│ • Generic move/scale     │       │ • Material-aware change  │
│ • No glass semantics     │       │ • Better continuity      │
│ • Can feel abrupt        │       │ • Can feel more natural  │
└──────────────────────────┘       └──────────────────────────┘
        ✅ BASIC                          ✅ CONTEXTUAL
```

**Key principle:** Use glass-specific transitions when they clarify state changes. If motion becomes decorative noise, prefer simpler transitions.

### 🎯 Key Takeaway

**Transition style should serve continuity, not spectacle.**

`glassEffectTransition` is most useful when related glass elements change state and the user benefits from smoother continuity. Under Reduce Motion, calmer behavior should take priority over visual flourish.

**The test:** Compare ordinary and glass transition modes across `materialize`, `matchedGeometry`, and `identity`, then enable Reduce Motion and verify the transition calms down.

---

## Stage 12 — Scrolling underneath glass

### 📋 What It's About
Stage 12 explores floating controls above rich scrolling content. It compares an incorrect opaque control bar that blocks the content relationship with a preferred adaptive glass control layer that stays legible while content moves beneath it.

### 🧠 Mental Model

```text
CONTENT SCROLLS UNDER
        ↓
CONTROL LAYER STAYS ELEVATED
        ↓
GLASS ADAPTS TO PRESERVE SEPARATION
```

If you place opaque surfaces at the top, the control layer disconnects from content. If you use adaptive material/glass, the control layer stays readable while still relating to motion and color below.

### 🎯 Key Takeaway

**Glass controls should float above content, not block it.**

When content scrolls beneath top controls, avoid hard opaque bars unless they are intentionally structural. Adaptive glass/material keeps hierarchy clear and maintains visual continuity as the underlying content changes.

**The test:** Scroll vibrant cards under both versions. In the incorrect version, the top panel feels pasted and disconnected. In the preferred version, controls remain clear while preserving a sense of depth and relationship to moving content.

---
