import SwiftUI

/// Stage 11 — GlassEffectTransition
///
/// Objective: Compare ordinary SwiftUI transitions with glass-specific transitions
/// and observe when continuity helps versus distracts.

struct Stage11_GlassTransition: View {
    private let reduceMotionOverride: Bool?
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var useGlassTransition = true
    @State private var selectedTransitionStyle: Stage11TransitionStyle = .matchedGeometry
    @State private var isExpanded = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(reduceMotionOverride: Bool? = nil) {
        self.reduceMotionOverride = reduceMotionOverride
    }

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 11: Glass Effect Transition")
                        .font(.headline)
                    Text("Ordinary transition vs. glass-specific transition")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage11Card(title: "Transition Demo") {
                            Text(useGlassTransition ? "Glass transition mode" : "Ordinary transition mode")
                                .font(.caption2)
                                .foregroundColor(useGlassTransition ? .green : .orange)

                            if useGlassTransition {
                                Stage11GlassTransitionDemo(
                                    isExpanded: $isExpanded,
                                    transitionStyle: selectedTransitionStyle,
                                    reduceMotion: effectiveReduceMotion
                                )
                            } else {
                                Stage11OrdinaryTransitionDemo(
                                    isExpanded: $isExpanded,
                                    reduceMotion: effectiveReduceMotion
                                )
                            }
                        }

                        Stage11Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("Materialize focuses on appearance/disappearance of material.")
                                BulletPointText("Matched geometry improves continuity when element identities are related.")
                                BulletPointText("Identity transition keeps transitions minimal and less distracting.")
                                BulletPointText("With Reduce Motion enabled, prefer calmer transition behavior.")
                            }
                            .font(.caption2)
                        }
                    }
                    .padding(16)
                }

                VStack(spacing: 12) {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Background")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Background", selection: $selectedBackground) {
                            ForEach(BackgroundSelection.allCases, id: \.self) { bg in
                                Text(bg.label).tag(bg)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Approach")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Approach", selection: $useGlassTransition) {
                            Text("Ordinary").tag(false)
                            Text("Glass Transition").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }

                    if useGlassTransition {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Glass Transition Type")
                                .font(.caption)
                                .fontWeight(.bold)

                            Picker("Transition Type", selection: $selectedTransitionStyle) {
                                ForEach(Stage11TransitionStyle.allCases, id: \.self) { style in
                                    Text(style.label).tag(style)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }

                    Button(isExpanded ? "Collapse" : "Expand") {
                        withAnimation(animationForMotionSetting) {
                            isExpanded.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }

    private var animationForMotionSetting: Animation {
        effectiveReduceMotion ? .easeOut(duration: 0.15) : .spring(response: 0.4, dampingFraction: 0.82)
    }

    private var effectiveReduceMotion: Bool {
        reduceMotionOverride ?? reduceMotion
    }
}

private enum Stage11TransitionStyle: String, CaseIterable {
    case materialize
    case matchedGeometry
    case identity

    var label: String {
        switch self {
        case .materialize: "Materialize"
        case .matchedGeometry: "Matched"
        case .identity: "Identity"
        }
    }
}

private struct Stage11OrdinaryTransitionDemo: View {
    @Binding var isExpanded: Bool
    let reduceMotion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ordinary transitions")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)

            HStack(spacing: 8) {
                Stage11PlainAction(title: "Base", systemImage: "circle.fill") {}

                if isExpanded {
                    Stage11PlainAction(title: "Extra", systemImage: "sparkles") {}
                        .transition(.move(edge: .trailing).combined(with: .opacity))

                    Stage11PlainAction(title: "Close", systemImage: "xmark") {}
                        .transition(reduceMotion ? .opacity : .scale.combined(with: .opacity))
                }
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage11GlassTransitionDemo: View {
    @Namespace private var namespace
    @Binding var isExpanded: Bool
    let transitionStyle: Stage11TransitionStyle
    let reduceMotion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Glass transitions")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)

            if #available(iOS 26, *) {
                GlassEffectContainer(spacing: 0) {
                    HStack(spacing: 0) {
                        Stage11IdentityAction(title: "Base", systemImage: "circle.fill", id: "base", namespace: namespace) {}

                        if isExpanded {
                            Stage11IdentityAction(title: "Extra", systemImage: "sparkles", id: "extra", unionID: "expanded-controls", namespace: namespace) {}
                                .glassEffectTransition(glassTransitionValue)

                            Stage11IdentityAction(title: "Close", systemImage: "xmark", id: "close", unionID: "expanded-controls", namespace: namespace) {}
                                .glassEffectTransition(glassTransitionValue)
                        }
                    }
                }
            } else {
                HStack(spacing: 8) {
                    Stage11PlainAction(title: "Base", systemImage: "circle.fill") {}

                    if isExpanded {
                        Stage11PlainAction(title: "Extra", systemImage: "sparkles") {}
                        Stage11PlainAction(title: "Close", systemImage: "xmark") {}
                    }
                }
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @available(iOS 26, *)
    private var glassTransitionValue: GlassEffectTransition {
        if reduceMotion {
            return .identity
        }

        switch transitionStyle {
        case .materialize:
            return .materialize
        case .matchedGeometry:
            return .matchedGeometry
        case .identity:
            return .identity
        }
    }
}

private struct Stage11PlainAction: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .background(.thinMaterial)
        .clipShape(Capsule())
    }
}

@available(iOS 26, *)
private struct Stage11IdentityAction: View {
    let title: String
    let systemImage: String
    let id: String
    var unionID: String? = nil
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
        .glassEffect(.regular.interactive(), in: Capsule())
        .glassEffectID(id, in: namespace)
        .stage11OptionalUnion(id: unionID, namespace: namespace)
    }
}

@available(iOS 26, *)
private extension View {
    @ViewBuilder
    func stage11OptionalUnion(id: String?, namespace: Namespace.ID) -> some View {
        if let id {
            self.glassEffectUnion(id: id, namespace: namespace)
        } else {
            self
        }
    }
}

private struct Stage11Card<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview("Stage 11 — Vibrant Background") {
    Stage11_GlassTransition()
}

#Preview("Stage 11 — Dark Mode") {
    Stage11_GlassTransition()
        .preferredColorScheme(.dark)
}

#Preview("Stage 11 — Large Type") {
    Stage11_GlassTransition()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 11 — Reduce Motion") {
    Stage11_GlassTransition(reduceMotionOverride: true)
}
