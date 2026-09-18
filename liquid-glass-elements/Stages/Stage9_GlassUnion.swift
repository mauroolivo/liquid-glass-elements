import SwiftUI

/// Stage 9 — Glass unions and grouped controls
///
/// Objective: Learn when related controls should visually merge into one unit.
/// Compare isolated glass buttons with grouped control clusters.
///
/// Mental model: semantic groups can share a visual system.

struct Stage9_GlassUnion: View {
    @Namespace private var unionNamespace
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showGrouped = true
    @State private var activeGroup: Stage9ControlGroup = .media

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 9: Glass Unions and Grouped Controls")
                        .font(.headline)
                    Text("Independent controls vs. coordinated clusters")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage9Card(title: "Prediction") {
                            Text("Do these controls feel like one tool, or like separate floating pieces?")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }

                        Stage9Card(title: showGrouped ? "Grouped version" : "Independent version") {
                            Text(showGrouped ? "These controls should read as one cluster." : "These controls intentionally stay separate.")
                                .font(.caption2)
                                .foregroundColor(showGrouped ? .green : .orange)

                            VStack(spacing: 12) {
                                Stage9SegmentedHeader(selectedGroup: $activeGroup)

                                if activeGroup == .media {
                                    Stage9MediaTransport(showGrouped: showGrouped, namespace: unionNamespace)
                                } else {
                                    Stage9FilterControls(showGrouped: showGrouped, namespace: unionNamespace)
                                }
                            }
                        }

                        Stage9Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("Union/grouping should reflect semantic relationship, not decoration.")
                                BulletPointText("Media transport buttons belong together more naturally than unrelated actions.")
                                BulletPointText("Filter controls often benefit from a shared visual unit.")
                                BulletPointText("If the group does not help the user understand the task, leave it separate.")
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

                        Picker("Grouping", selection: $showGrouped) {
                            Text("Independent").tag(false)
                            Text("Grouped").tag(true)
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

private enum Stage9ControlGroup: String, CaseIterable {
    case media
    case filters

    var label: String {
        switch self {
        case .media: "Media"
        case .filters: "Filters"
        }
    }
}

private struct Stage9SegmentedHeader: View {
    @Binding var selectedGroup: Stage9ControlGroup

    var body: some View {
        Picker("Control Group", selection: $selectedGroup) {
            ForEach(Stage9ControlGroup.allCases, id: \.self) { group in
                Text(group.label).tag(group)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct Stage9MediaTransport: View {
    let showGrouped: Bool
    let namespace: Namespace.ID

    var body: some View {
        Stage9ControlCard(title: "Media Transport", subtitle: "Previous / Play / Next") {
            if showGrouped {
                groupedMediaCluster
            } else {
                independentMediaCluster
            }
        }
    }

    private var independentMediaCluster: some View {
        VStack(spacing: 10) {
            Stage9StandaloneButtonCard(title: "Previous") {
                Stage9GlassButton(title: "Prev", systemImage: "chevron.left") {}
            }

            Stage9StandaloneButtonCard(title: "Play") {
                Stage9GlassButton(title: "Play", systemImage: "play.fill") {}
            }

            Stage9StandaloneButtonCard(title: "Next") {
                Stage9GlassButton(title: "Next", systemImage: "chevron.right") {}
            }
        }
    }

    private var groupedMediaCluster: some View {
        Group {
            if #available(iOS 18, *) {
                GlassEffectContainer {
                    HStack(spacing: 20) {
                        Stage9UnionGlassButton(title: "Prev", systemImage: "chevron.left", unionID: "media-transport", namespace: namespace) {}
                        Stage9UnionGlassButton(title: "Play", systemImage: "play.fill", unionID: "media-transport", namespace: namespace) {}
                        Stage9UnionGlassButton(title: "Next", systemImage: "chevron.right", unionID: "media-transport", namespace: namespace) {}
                    }
                }
            } else {
                HStack(spacing: 20) {
                    Stage9GlassButton(title: "Prev", systemImage: "chevron.left") {}
                    Stage9GlassButton(title: "Play", systemImage: "play.fill") {}
                    Stage9GlassButton(title: "Next", systemImage: "chevron.right") {}
                }
            }
        }
    }
}

private struct Stage9FilterControls: View {
    let showGrouped: Bool
    let namespace: Namespace.ID

    var body: some View {
        Stage9ControlCard(title: "Filter Controls", subtitle: "Filter / Sort / Options") {
            if showGrouped {
                groupedFilterCluster
            } else {
                independentFilterCluster
            }
        }
    }

    private var independentFilterCluster: some View {
        VStack(spacing: 10) {
            Stage9StandaloneButtonCard(title: "Filter") {
                Stage9GlassButton(title: "Filter", systemImage: "line.3.horizontal.decrease.circle") {}
            }

            Stage9StandaloneButtonCard(title: "Sort") {
                Stage9GlassButton(title: "Sort", systemImage: "arrow.up.arrow.down") {}
            }

            Stage9StandaloneButtonCard(title: "Options") {
                Stage9GlassButton(title: "Options", systemImage: "ellipsis.circle") {}
            }
        }
    }

    private var groupedFilterCluster: some View {
        Group {
            if #available(iOS 18, *) {
                GlassEffectContainer {
                    HStack(spacing: 18) {
                        Stage9UnionGlassButton(title: "Filter", systemImage: "line.3.horizontal.decrease.circle", unionID: "filter-controls", namespace: namespace) {}
                        Stage9UnionGlassButton(title: "Sort", systemImage: "arrow.up.arrow.down", unionID: "filter-controls", namespace: namespace) {}
                        Stage9UnionGlassButton(title: "Options", systemImage: "ellipsis.circle", unionID: "filter-controls", namespace: namespace) {}
                    }
                }
            } else {
                HStack(spacing: 18) {
                    Stage9GlassButton(title: "Filter", systemImage: "line.3.horizontal.decrease.circle") {}
                    Stage9GlassButton(title: "Sort", systemImage: "arrow.up.arrow.down") {}
                    Stage9GlassButton(title: "Options", systemImage: "ellipsis.circle") {}
                }
            }
        }
    }
}

private struct Stage9StandaloneButtonCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct Stage9GlassButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .fixedSize(horizontal: true, vertical: false)
        }
        .foregroundColor(.primary)
        .buttonStyle(.plain)
        .stage9GlassSurface()
    }
}

private struct Stage9UnionGlassButton: View {
    let title: String
    let systemImage: String
    let unionID: String
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .fixedSize(horizontal: true, vertical: false)
        }
        .buttonStyle(.glass)
        .foregroundColor(.primary)
        .glassEffectUnion(id: unionID, namespace: namespace)
    }
}

private extension View {
    @ViewBuilder
    func stage9GlassSurface() -> some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

        if #available(iOS 18, *) {
            self
                .glassEffect()
                .clipShape(shape)
        } else {
            self
                .background(Material.thin)
                .clipShape(shape)
        }
    }
}

private struct Stage9ControlCard<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .cornerRadius(12)
    }
}

private struct Stage9Card<Content: View>: View {
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

#Preview("Stage 9 — Vibrant Background") {
    Stage9_GlassUnion()
}

#Preview("Stage 9 — Dark Mode") {
    Stage9_GlassUnion()
        .preferredColorScheme(.dark)
}

#Preview("Stage 9 — Large Type") {
    Stage9_GlassUnion()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
