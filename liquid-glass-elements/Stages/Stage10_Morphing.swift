import SwiftUI

/// Stage 10 — Morphing and glass identity
///
/// Objective: Compare a plain expandable menu transition with one that gives
/// Liquid Glass stable semantic identity during expansion and collapse.
///
/// Mental model: the user should feel one control becoming a related control,
/// not one control disappearing while another appears.

struct Stage10_Morphing: View {
    @Namespace private var glassNamespace
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var useGlassIdentity = true
    @State private var isExpanded = false

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 10: Morphing and Glass Identity")
                        .font(.headline)
                    Text("Ordinary transition vs. semantic glass identity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    VStack(spacing: 14) {
                        Stage10Card(title: "Prediction") {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("When [+] expands into [Photo] [Camera] [Close], which element should preserve identity?")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)

                                Text("Hint: the compact trigger and the close control represent the same menu toggle role.")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Stage10Card(title: useGlassIdentity ? "With glass identity" : "Without glass identity") {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(useGlassIdentity ? "The menu toggle keeps semantic identity during the transition." : "The menu simply swaps states without a persistent glass identity.")
                                    .font(.caption2)
                                    .foregroundColor(useGlassIdentity ? .green : .orange)

                                if useGlassIdentity {
                                    Stage10IdentityMorphMenu(isExpanded: $isExpanded, namespace: glassNamespace)
                                } else {
                                    Stage10OrdinaryMorphMenu(isExpanded: $isExpanded)
                                }
                            }
                        }

                        Stage10Card(title: "Observation") {
                            VStack(alignment: .leading, spacing: 6) {
                                BulletPointText("Without identity, the compact trigger and expanded close button feel unrelated.")
                                BulletPointText("With glass identity, one control can feel like it becomes another state of the same control.")
                                BulletPointText("Identity should follow semantic meaning, not arbitrary geometry.")
                                BulletPointText("Morphing improves continuity only when the relationship is real.")
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

                        Picker("Approach", selection: $useGlassIdentity) {
                            Text("Ordinary").tag(false)
                            Text("Glass Identity").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }

                    Button(isExpanded ? "Collapse Menu" : "Expand Menu") {
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
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
}

private struct Stage10OrdinaryMorphMenu: View {
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ordinary transition")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)

            Group {
                if isExpanded {
                    HStack(spacing: 8) {
                        Stage10OrdinaryAction(title: "Photo", systemImage: "photo") { }
                            .transition(.move(edge: .leading).combined(with: .opacity))

                        Stage10OrdinaryAction(title: "Camera", systemImage: "camera") { }
                            .transition(.scale.combined(with: .opacity))

                        Stage10OrdinaryAction(title: "Close", systemImage: "xmark") {
                            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                isExpanded = false
                            }
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                } else {
                    Stage10OrdinaryAction(title: "Add", systemImage: "plus") {
                        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                            isExpanded = true
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: 260, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage10IdentityMorphMenu: View {
    @Binding var isExpanded: Bool
    let namespace: Namespace.ID

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Glass identity")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)

            Group {
                if #available(iOS 26, *) {
                    if isExpanded {
                        GlassEffectContainer(spacing: 0) {
                            HStack(spacing: 0) {
                                Stage10IdentityAction(title: "Photo", systemImage: "photo", glassID: "photo", unionID: "expanded-menu", namespace: namespace) { }
                                    .transition(.move(edge: .leading).combined(with: .opacity))

                                Stage10IdentityAction(title: "Camera", systemImage: "camera", glassID: "camera", unionID: "expanded-menu", namespace: namespace) { }
                                    .transition(.scale.combined(with: .opacity))

                                Stage10IdentityAction(title: "Close", systemImage: "xmark", glassID: "menu-toggle", unionID: "expanded-menu", namespace: namespace) {
                                    withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                        isExpanded = false
                                    }
                                }
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                    } else {
                        Stage10IdentityAction(title: "Add", systemImage: "plus", glassID: "menu-toggle", namespace: namespace) {
                            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                isExpanded = true
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    if isExpanded {
                        HStack(spacing: 8) {
                            Stage10FallbackAction(title: "Photo", systemImage: "photo") { }
                            Stage10FallbackAction(title: "Camera", systemImage: "camera") { }
                            Stage10FallbackAction(title: "Close", systemImage: "xmark") {
                                withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                    isExpanded = false
                                }
                            }
                        }
                    } else {
                        Stage10FallbackAction(title: "Add", systemImage: "plus") {
                            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                isExpanded = true
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            }
            .frame(maxWidth: 260, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color.gray.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage10OrdinaryAction: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Stage10RowLabel(title: title, systemImage: systemImage)
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
        .background(.thinMaterial)
        .clipShape(Capsule())
    }
}

@available(iOS 26, *)
private struct Stage10IdentityAction: View {
    let title: String
    let systemImage: String
    let glassID: String
    var unionID: String? = nil
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Stage10RowLabel(title: title, systemImage: systemImage)
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
        .glassEffect(.regular.interactive(), in: Capsule())
        .glassEffectID(glassID, in: namespace)
        .stage10OptionalUnion(id: unionID, namespace: namespace)
    }
}

@available(iOS 26, *)
private extension View {
    @ViewBuilder
    func stage10OptionalUnion(id: String?, namespace: Namespace.ID) -> some View {
        if let id {
            self.glassEffectUnion(id: id, namespace: namespace)
        } else {
            self
        }
    }
}

private struct Stage10FallbackAction: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Stage10RowLabel(title: title, systemImage: systemImage)
        }
        .buttonStyle(.borderedProminent)
    }
}

private struct Stage10RowLabel: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .frame(width: 18)

            Text(title)
                .lineLimit(1)
        }
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

private struct Stage10Card<Content: View>: View {
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

#Preview("Stage 10 — Vibrant Background") {
    Stage10_Morphing()
}

#Preview("Stage 10 — Dark Mode") {
    Stage10_Morphing()
        .preferredColorScheme(.dark)
}

#Preview("Stage 10 — Large Type") {
    Stage10_Morphing()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
