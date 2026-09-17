import SwiftUI

/// Stage 5 - Glass buttons and interaction
///
/// Objective: Compare button styles and decide where prominence is justified.
/// Focus on hierarchy, press behavior, and semantic role.

struct Stage5_GlassButtons: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showAllProminent = true
    @State private var lastAction = "None"

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 5: Glass Buttons and Interaction")
                        .font(.headline)
                    Text("Compare styles, then reduce prominence intentionally")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage5Card(title: "Style Gallery") {
                            Text("Same action rendered with different styles")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            VStack(spacing: 8) {
                                Stage5StyledButton(title: "Plain", systemImage: "paperplane.fill", style: .plain) {
                                    lastAction = "Plain"
                                }

                                Stage5StyledButton(title: "Bordered", systemImage: "paperplane.fill", style: .bordered) {
                                    lastAction = "Bordered"
                                }

                                Stage5StyledButton(title: "Bordered Prominent", systemImage: "paperplane.fill", style: .borderedProminent) {
                                    lastAction = "Bordered Prominent"
                                }

                                Stage5StyledButton(title: "Glass", systemImage: "paperplane.fill", style: .glass) {
                                    lastAction = "Glass"
                                }

                                Stage5StyledButton(title: "Glass Prominent", systemImage: "paperplane.fill", style: .glassProminent) {
                                    lastAction = "Glass Prominent"
                                }
                            }
                        }

                        Stage5Card(title: "Action Hierarchy") {
                            Text(showAllProminent ? "Incorrect: all actions are prominent" : "Preferred: only primary action is prominent")
                                .font(.caption2)
                                .foregroundColor(showAllProminent ? .red : .green)

                            VStack(spacing: 10) {
                                Stage5RoleButton(
                                    title: "Publish",
                                    systemImage: "arrow.up.circle.fill",
                                    role: .primary,
                                    allProminent: showAllProminent
                                ) {
                                    lastAction = "Publish"
                                }

                                Stage5RoleButton(
                                    title: "Save Draft",
                                    systemImage: "tray.and.arrow.down",
                                    role: .secondary,
                                    allProminent: showAllProminent
                                ) {
                                    lastAction = "Save Draft"
                                }

                                Stage5RoleButton(
                                    title: "Open Details",
                                    systemImage: "chevron.right.circle",
                                    role: .navigation,
                                    allProminent: showAllProminent
                                ) {
                                    lastAction = "Open Details"
                                }

                                Stage5RoleButton(
                                    title: "Delete",
                                    systemImage: "trash",
                                    role: .destructive,
                                    allProminent: showAllProminent
                                ) {
                                    lastAction = "Delete"
                                }
                            }
                        }

                        Stage5Card(title: "Interaction Feedback") {
                            Text("Last tapped action: \(lastAction)")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Text("Press each style and observe highlight/press behavior. On iOS 18+, glass styles provide distinct interaction treatment.")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Stage5Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("If everything is prominent, nothing is primary.")
                                BulletPointText("Primary action may deserve glassProminent.")
                                BulletPointText("Secondary/navigation usually use glass or bordered.")
                                BulletPointText("Destructive should be obvious but not visually noisy.")
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
                        Text("Prominence Strategy")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Prominence", selection: $showAllProminent) {
                            Text("Incorrect: all prominent").tag(true)
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

private enum Stage5DemoStyle {
    case plain
    case bordered
    case borderedProminent
    case glass
    case glassProminent
}

private enum Stage5Role {
    case primary
    case secondary
    case destructive
    case navigation
}

private struct Stage5StyledButton: View {
    let title: String
    let systemImage: String
    let style: Stage5DemoStyle
    let action: () -> Void

    var body: some View {
        let base = Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }

        switch style {
        case .plain:
            base.buttonStyle(.plain)
        case .bordered:
            base.buttonStyle(.bordered)
        case .borderedProminent:
            base.buttonStyle(.borderedProminent)
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

private struct Stage5RoleButton: View {
    let title: String
    let systemImage: String
    let role: Stage5Role
    let allProminent: Bool
    let action: () -> Void

    var body: some View {
        let base = Button(action: action) {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .tint(roleTint)

        if allProminent {
            if #available(iOS 18, *) {
                base.buttonStyle(.glassProminent)
            } else {
                base.buttonStyle(.borderedProminent)
            }
        } else {
            switch role {
            case .primary:
                if #available(iOS 18, *) {
                    base.buttonStyle(.glassProminent)
                } else {
                    base.buttonStyle(.borderedProminent)
                }
            case .secondary, .navigation:
                if #available(iOS 18, *) {
                    base.buttonStyle(.glass)
                } else {
                    base.buttonStyle(.bordered)
                }
            case .destructive:
                base.buttonStyle(.bordered)
            }
        }
    }

    private var roleTint: Color {
        switch role {
        case .primary: return .blue
        case .secondary: return .indigo
        case .destructive: return .red
        case .navigation: return .teal
        }
    }
}

private struct Stage5Card<Content: View>: View {
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

#Preview("Stage 5 - Standard") {
    Stage5_GlassButtons()
}

#Preview("Stage 5 - Dark") {
    Stage5_GlassButtons()
        .preferredColorScheme(.dark)
}

#Preview("Stage 5 - Large Type") {
    Stage5_GlassButtons()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
