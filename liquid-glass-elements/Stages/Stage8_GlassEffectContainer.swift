import SwiftUI

/// Stage 8 — GlassEffectContainer
///
/// Objective: Compare nearby glass elements rendered independently vs. inside a
/// GlassEffectContainer. Learn when grouping improves coherence.
///
/// Mental model: related glass belongs to one visual system.

struct Stage8_GlassEffectContainer: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var useContainer = true
    @State private var spacing: CGFloat = 16

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 8: GlassEffectContainer")
                        .font(.headline)
                    Text("Independent glass vs. coordinated glass")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage8Card(title: "Prediction") {
                            Text("Do these nearby glass buttons feel like a coordinated group, or three separate floating pieces?")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Stage8Card(title: useContainer ? "Grouped in GlassEffectContainer" : "Independent glass elements") {
                            Text(useContainer ? "These controls are intentionally coordinated." : "These controls are rendered independently.")
                                .font(.caption2)
                                .foregroundColor(useContainer ? .green : .orange)

                            if useContainer {
                                glassContainerCluster
                            } else {
                                independentCluster
                            }
                        }

                        Stage8Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("GlassEffectContainer coordinates related shapes.")
                                BulletPointText("Near elements can feel more like one control system.")
                                BulletPointText("Spacing changes the visual relationship between glass pieces.")
                                BulletPointText("Grouping is about semantics, not novelty.")
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
                        Text("Grouping")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Grouping", selection: $useContainer) {
                            Text("Independent").tag(false)
                            Text("Grouped").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Spacing: \(Int(spacing))")
                            .font(.caption)
                            .fontWeight(.bold)

                        Slider(value: $spacing, in: 0...28, step: 1)
                    }
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }

    private var independentCluster: some View {
        HStack(spacing: spacing) {
            Stage8GlassButton(title: "Prev", systemImage: "chevron.left") {}
            Stage8GlassButton(title: "Play", systemImage: "play.fill") {}
            Stage8GlassButton(title: "Next", systemImage: "chevron.right") {}
        }
    }

    private var glassContainerCluster: some View {
        Group {
            if #available(iOS 18, *) {
                GlassEffectContainer(spacing: spacing) {
                    HStack(spacing: spacing) {
                        Stage8GlassButton(title: "Prev", systemImage: "chevron.left") {}
                        Stage8GlassButton(title: "Play", systemImage: "play.fill") {}
                        Stage8GlassButton(title: "Next", systemImage: "chevron.right") {}
                    }
                }
            } else {
                HStack(spacing: spacing) {
                    Stage8GlassButton(title: "Prev", systemImage: "chevron.left") {}
                    Stage8GlassButton(title: "Play", systemImage: "play.fill") {}
                    Stage8GlassButton(title: "Next", systemImage: "chevron.right") {}
                }
            }
        }
    }
}

private struct Stage8GlassButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
        }
        .foregroundColor(.primary)
        .buttonStyle(.glass)
//        .buttonStyle(.plain)
//        .ifAvailableGlassStyle()
    }
}

private extension View {
    @ViewBuilder
    func ifAvailableGlassStyle() -> some View {
        self.buttonStyle(.glass)
    }
}

private struct Stage8Card<Content: View>: View {
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
        .cornerRadius(12)
    }
}

#Preview("Stage 8 — Vibrant Background") {
    Stage8_GlassEffectContainer()
}

#Preview("Stage 8 — Dark Mode") {
    Stage8_GlassEffectContainer()
        .preferredColorScheme(.dark)
}

#Preview("Stage 8 — Large Type") {
    Stage8_GlassEffectContainer()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
