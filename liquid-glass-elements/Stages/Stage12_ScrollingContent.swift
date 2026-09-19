import SwiftUI

/// Stage 12 — Scrolling underneath glass
///
/// Objective: Observe how floating controls relate to moving content.
/// Compare an opaque blocker (incorrect) with adaptive glass (preferred).

struct Stage12_ScrollingContent: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showPreferred = true
    @State private var selectedSection = 0

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 12: Scrolling Underneath Glass")
                        .font(.headline)
                    Text("Opaque blocker vs adaptive glass over scrolling content")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(spacing: 14) {
                            Stage12SectionPicker(selectedSection: $selectedSection)

                            ForEach(0..<12, id: \.self) { index in
                                Stage12ContentCard(index: index, selectedSection: selectedSection)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 80)
                        .padding(.bottom, 24)
                    }

                    if showPreferred {
                        Stage12PreferredFloatingControls(selectedSection: $selectedSection)
                            .padding(.top, 12)
                    } else {
                        Stage12IncorrectFloatingControls(selectedSection: $selectedSection)
                            .padding(.top, 12)
                    }
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
                        Text("Implementation")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Implementation", selection: $showPreferred) {
                            Text("Incorrect").tag(false)
                            Text("Preferred").tag(true)
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

private struct Stage12SectionPicker: View {
    @Binding var selectedSection: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Scroll Content")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)

            Picker("Section", selection: $selectedSection) {
                Text("Nature").tag(0)
                Text("Tech").tag(1)
                Text("Design").tag(2)
            }
            .pickerStyle(.segmented)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct Stage12ContentCard: View {
    let index: Int
    let selectedSection: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(gradientForCard)
                .frame(height: 140)
                .overlay(alignment: .bottomLeading) {
                    Text("Scene \(index + 1)")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(.black.opacity(0.35))
                        .clipShape(Capsule())
                        .padding(10)
                }

            Text(titleForCard)
                .font(.headline)

            Text("As this content scrolls under floating controls, the top control layer should remain legible and related to what is beneath. Opaque blockers break that relationship.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var gradientForCard: LinearGradient {
        let palettes: [[Color]] = [
            [.purple, .mint],
            [.blue, .orange],
            [.pink, .cyan]
        ]
        let colors = palettes[selectedSection % palettes.count]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    private var titleForCard: String {
        switch selectedSection {
        case 0: return "Nature Story \(index + 1)"
        case 1: return "Tech Story \(index + 1)"
        default: return "Design Story \(index + 1)"
        }
    }
}

private struct Stage12IncorrectFloatingControls: View {
    @Binding var selectedSection: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Button(action: { selectedSection = 0 }) {
                    Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)

                Button(action: { selectedSection = (selectedSection + 1) % 3 }) {
                    Label("Next", systemImage: "arrow.right")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
                .buttonStyle(.plain)
            }
            .foregroundColor(.white)
            .background(Color.black.opacity(0.82))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text("Incorrect: opaque panel blocks relationship to content")
                .font(.caption2)
                .foregroundColor(.red)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct Stage12PreferredFloatingControls: View {
    @Binding var selectedSection: Int

    var body: some View {
        VStack(spacing: 10) {
            if #available(iOS 26, *) {
                GlassEffectContainer(spacing: 0) {
                    HStack(spacing: 0) {
                        Stage12GlassAction(title: "Filter", systemImage: "line.3.horizontal.decrease.circle", id: "filter") {
                            selectedSection = 0
                        }
                        Stage12GlassAction(title: "Next", systemImage: "arrow.right", id: "next") {
                            selectedSection = (selectedSection + 1) % 3
                        }
                    }
                }
            } else {
                HStack(spacing: 8) {
                    Button(action: { selectedSection = 0 }) {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)

                    Button(action: { selectedSection = (selectedSection + 1) % 3 }) {
                        Label("Next", systemImage: "arrow.right")
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            Text("Preferred: adaptive glass stays elevated while content moves")
                .font(.caption2)
                .foregroundColor(.green)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

@available(iOS 26, *)
private struct Stage12GlassAction: View {
    let title: String
    let systemImage: String
    let id: String
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
    }

    @Namespace private var namespace
}

#Preview("Stage 12 — Vibrant Background") {
    Stage12_ScrollingContent()
}

#Preview("Stage 12 — Dark Mode") {
    Stage12_ScrollingContent()
        .preferredColorScheme(.dark)
}

#Preview("Stage 12 — Large Type") {
    Stage12_ScrollingContent()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 12 — Reduce Motion") {
    Stage12_ScrollingContent()
}
