import SwiftUI

/// Stage 6 — Interactive custom glass
///
/// Objective: Compare decorative glass that only looks interactive with a real
/// interactive control that changes state and exposes semantics.
///
/// Mental model: visual presence != interaction semantics.

struct Stage6_InteractiveCustomGlass: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 6: Interactive Custom Glass")
                        .font(.headline)
                    Text("Decorative glass vs. interactive glass")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage6Card(title: "Decorative Glass") {
                            Text("Looks like a control, but it does not behave like one.")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            VStack(spacing: 12) {
                                Label("Favorite", systemImage: "heart.fill")
                                    .font(.headline)

                                Text("This surface has visual presence, but no interaction semantics, no press feedback, and no state change.")
                                    .font(.caption2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Material.thin)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .allowsHitTesting(false)
                            .overlay(alignment: .topTrailing) {
                                Text("DECORATIVE")
                                    .font(.caption2.bold())
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.red.opacity(0.12))
                                    .clipShape(Capsule())
                                    .offset(x: -10, y: 10)
                            }
                        }

                        Stage6InteractiveGlassControl()

                        Stage6Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("Visual glass alone does not make something interactive.")
                                BulletPointText("A real control should press, change state, and expose meaning.")
                                BulletPointText("Hover and press feedback help the user trust the control.")
                                BulletPointText("Use glass where the control deserves emphasis, not as decoration.")
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

                    Text("Compare a glass-looking decoration with a real interactive glass control.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

private struct Stage6InteractiveGlassControl: View {
    @State private var isExpanded = false
    @State private var tapCount = 0

    var body: some View {
        Stage6Card(title: "Interactive Glass") {
            Text("This one changes state, shows press feedback, and communicates intent.")
                .font(.caption2)
                .foregroundColor(.secondary)

            Button {
                tapCount += 1
                isExpanded.toggle()
            } label: {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.title2)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(isExpanded ? "Collapse Details" : "Expand Details")
                                .font(.headline)
                            Text("Taps: \(tapCount)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }

                    if isExpanded {
                        Text("Interactive semantics matter: the control responds to press, communicates state, and reveals additional content when activated.")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                }
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .stage6InteractiveGlassSurface()
            }
            .buttonStyle(.plain)
            .hoverEffect(.lift)
            .accessibilityLabel(isExpanded ? "Collapse details" : "Expand details")
            .accessibilityHint("Toggles additional information and updates the tap count.")
        }
    }
}

private struct Stage6Card<Content: View>: View {
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

private extension View {
    @ViewBuilder
    func stage6InteractiveGlassSurface() -> some View {
        let shape = RoundedRectangle(cornerRadius: 20, style: .continuous)

        if #available(iOS 18, *) {
            self
                .glassEffect()
                .clipShape(shape)
        } else {
            self
                .background(Material.regular)
                .clipShape(shape)
        }
    }
}

#Preview("Stage 6 — Vibrant Background") {
    Stage6_InteractiveCustomGlass()
}

#Preview("Stage 6 — Dark Mode") {
    Stage6_InteractiveCustomGlass()
        .preferredColorScheme(.dark)
}

#Preview("Stage 6 — Large Type") {
    Stage6_InteractiveCustomGlass()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
