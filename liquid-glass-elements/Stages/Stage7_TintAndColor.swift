import SwiftUI

/// Stage 7 — Tint, prominence and semantic color
///
/// Objective: Learn when tint communicates meaning versus when it becomes noise.
/// Compare neutral, tinted, and prominent glass across semantic actions.
///
/// Mental model: glass already provides presence; tint should add meaning.

struct Stage7_TintAndColor: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showOversaturated = true
    @State private var lastAction = "None"

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 7: Tint, Prominence and Semantic Color")
                        .font(.headline)
                    Text("Tint should communicate something; glass already has presence")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage7Card(title: "Style Gallery") {
                            Text("Same action shown with neutral, tinted, and prominent treatments.")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            VStack(spacing: 10) {
                                Stage7GalleryButton(
                                    title: "Neutral",
                                    systemImage: "circle.dashed",
                                    tint: nil,
                                    style: .plain,
                                    action: { lastAction = "Neutral" }
                                )

                                Stage7GalleryButton(
                                    title: "Bordered",
                                    systemImage: "circle",
                                    tint: .blue,
                                    style: .bordered,
                                    action: { lastAction = "Bordered" }
                                )

                                Stage7GalleryButton(
                                    title: "Glass",
                                    systemImage: "drop.fill",
                                    tint: .teal,
                                    style: .glass,
                                    action: { lastAction = "Glass" }
                                )

                                Stage7GalleryButton(
                                    title: "Glass Prominent",
                                    systemImage: "sparkles",
                                    tint: .purple,
                                    style: .glassProminent,
                                    action: { lastAction = "Glass Prominent" }
                                )
                            }
                        }

                        Stage7Card(title: "Semantic Action Lab") {
                            Text(showOversaturated ? "Incorrect: every action is loud and competing" : "Preferred: tint only where semantic meaning helps")
                                .font(.caption2)
                                .foregroundColor(showOversaturated ? .red : .green)

                            VStack(spacing: 10) {
                                Stage7SemanticButton(
                                    title: "Play",
                                    systemImage: "play.fill",
                                    role: .play,
                                    oversaturated: showOversaturated
                                ) {
                                    lastAction = "Play"
                                }

                                Stage7SemanticButton(
                                    title: "Favorite",
                                    systemImage: "heart.fill",
                                    role: .favorite,
                                    oversaturated: showOversaturated
                                ) {
                                    lastAction = "Favorite"
                                }

                                Stage7SemanticButton(
                                    title: "Confirm",
                                    systemImage: "checkmark.circle.fill",
                                    role: .confirm,
                                    oversaturated: showOversaturated
                                ) {
                                    lastAction = "Confirm"
                                }

                                Stage7SemanticButton(
                                    title: "Delete",
                                    systemImage: "trash.fill",
                                    role: .delete,
                                    oversaturated: showOversaturated
                                ) {
                                    lastAction = "Delete"
                                }

                                Stage7SemanticButton(
                                    title: "Record",
                                    systemImage: "record.circle",
                                    role: .record,
                                    oversaturated: showOversaturated
                                ) {
                                    lastAction = "Record"
                                }
                            }
                        }

                        Stage7Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("Glass already gives buttons enough presence; tint should add semantic meaning.")
                                BulletPointText("If every control is tinted and prominent, hierarchy becomes noisy.")
                                BulletPointText("Use tint to reinforce role: play, favorite, confirm, delete, record.")
                                BulletPointText("Keep non-primary controls lighter unless their meaning truly needs emphasis.")
                            }
                            .font(.caption2)
                        }

                        Stage7Card(title: "Interaction Feedback") {
                            Text("Last tapped action: \(lastAction)")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Text("Tap each button and compare how tint changes the perceived priority of the control.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
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
                        Text("Tint Strategy")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Strategy", selection: $showOversaturated) {
                            Text("Incorrect: all loud").tag(true)
                            Text("Preferred: selective").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

private enum Stage7GalleryStyle {
    case plain
    case bordered
    case glass
    case glassProminent
}

private enum Stage7SemanticRole {
    case play
    case favorite
    case confirm
    case delete
    case record

    var tint: Color {
        switch self {
        case .play: return .blue
        case .favorite: return .pink
        case .confirm: return .green
        case .delete: return .red
        case .record: return .orange
        }
    }
}

private struct Stage7GalleryButton: View {
    let title: String
    let systemImage: String
    let tint: Color?
    let style: Stage7GalleryStyle
    let action: () -> Void

    var body: some View {
        let base = Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .tint(tint)

        switch style {
        case .plain:
            base.buttonStyle(.plain)
        case .bordered:
            base.buttonStyle(.bordered)
        case .glass:
            if #available(iOS 18, *) {
                base.buttonStyle(.glass)
            } else {
                base.buttonStyle(.bordered)
            }
        case .glassProminent:
            if #available(iOS 18, *) {
                base.buttonStyle(.glassProminent)
            } else {
                base.buttonStyle(.borderedProminent)
            }
        }
    }
}

private struct Stage7SemanticButton: View {
    let title: String
    let systemImage: String
    let role: Stage7SemanticRole
    let oversaturated: Bool
    let action: () -> Void

    var body: some View {
        let base = Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .tint(role.tint)

        if oversaturated {
            if #available(iOS 18, *) {
                base.buttonStyle(.glassProminent)
            } else {
                base.buttonStyle(.borderedProminent)
            }
        } else {
            switch role {
            case .play:
                if #available(iOS 18, *) {
                    base.buttonStyle(.glassProminent)
                } else {
                    base.buttonStyle(.borderedProminent)
                }
            case .favorite, .confirm, .record:
                if #available(iOS 18, *) {
                    base.buttonStyle(.glass)
                } else {
                    base.buttonStyle(.bordered)
                }
            case .delete:
                base.buttonStyle(.bordered)
            }
        }
    }
}

private struct Stage7Card<Content: View>: View {
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

#Preview("Stage 7 — Vibrant Background") {
    Stage7_TintAndColor()
}

#Preview("Stage 7 — Dark Mode") {
    Stage7_TintAndColor()
        .preferredColorScheme(.dark)
}

#Preview("Stage 7 — Large Type") {
    Stage7_TintAndColor()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
