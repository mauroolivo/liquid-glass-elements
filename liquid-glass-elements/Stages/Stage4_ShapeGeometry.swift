import SwiftUI

/// Stage 4 — Glass Shape and Geometry
///
/// Objective: Learn how geometry choices (shape, corner radius, spacing, padding,
/// and control size) change the perceived quality and hierarchy of glass controls.
///
/// Mental model: Coherent geometry makes controls feel like one system.

struct Stage4_ShapeGeometry: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showPreferred = false

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Stage 4: Shape and Geometry")
                        .font(.headline)
                    Text("Incorrect geometry vs. coherent geometry")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)

                ScrollView {
                    if showPreferred {
                        Stage4PreferredGeometry()
                    } else {
                        Stage4IncorrectGeometry()
                    }
                }

                VStack(spacing: 12) {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Test Background:")
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
                        Text("Implementation:")
                            .font(.caption)
                            .fontWeight(.bold)

                        Picker("Version", selection: $showPreferred) {
                            Text("Incorrect").tag(false)
                            Text("Preferred").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }

                    Text("Focus on corner radius, touch target size, spacing rhythm, and shape coherence.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

struct Stage4IncorrectGeometry: View {
    var body: some View {
        VStack(spacing: 14) {
            Stage4Header(
                title: "Incorrect Geometry",
                subtitle: "Tiny radii, uneven spacing, inconsistent shape language",
                color: .red
            )

            // 1) Icon button - too square and cramped
            Stage4Card(title: "Icon Button") {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .padding(6)
                        .background(.thinMaterial)
                        .cornerRadius(2)
                    Spacer()
                }
            }

            // 2) Text button - too tall radius mismatch and poor padding
            Stage4Card(title: "Text Button") {
                HStack {
                    Text("Save")
                        .font(.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                    Spacer()
                }
            }

            // 3) Segmented actions - uneven and inconsistent sizes
            Stage4Card(title: "Segmented Actions") {
                HStack(spacing: 3) {
                    Text("All")
                        .font(.caption2)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 4)
                        .background(.thinMaterial)
                        .cornerRadius(3)

                    Text("Favorites")
                        .font(.caption)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(14)

                    Text("Recent")
                        .font(.caption2)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 5)
                        .background(.thinMaterial)
                        .cornerRadius(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 4) Large floating action - shape too sharp and text cramped
            Stage4Card(title: "Large Floating Action") {
                HStack {
                    Label("Create", systemImage: "plus")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(.thinMaterial)
                        .cornerRadius(4)
                    Spacer()
                }
            }

            // 5) Badge action - too large corner for tiny surface
            Stage4Card(title: "Badge Action") {
                HStack {
                    Text("NEW")
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(.thinMaterial)
                        .cornerRadius(12)
                    Spacer()
                }
            }

            Stage4Observation(
                text: "Problem: controls do not feel related. Touch targets are inconsistent, shape language is random, and hierarchy feels accidental."
            )
        }
        .padding(16)
    }
}

struct Stage4PreferredGeometry: View {
    var body: some View {
        VStack(spacing: 14) {
            Stage4Header(
                title: "Preferred Geometry",
                subtitle: "Consistent radii, spacing rhythm, and control scale",
                color: .green
            )

            // 1) Icon button - circle + proper target
            Stage4Card(title: "Icon Button") {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 42, height: 42)
                        .background(.thinMaterial)
                        .clipShape(Circle())
                    Spacer()
                }
            }

            // 2) Text button - capsule with readable padding
            Stage4Card(title: "Text Button") {
                HStack {
                    Text("Save")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                    Spacer()
                }
            }

            // 3) Segmented actions - coherent rounded chips
            Stage4Card(title: "Segmented Actions") {
                HStack(spacing: 8) {
                    Stage4Chip("All", isSelected: true)
                    Stage4Chip("Favorites", isSelected: false)
                    Stage4Chip("Recent", isSelected: false)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            // 4) Large floating action - prominent capsule
            Stage4Card(title: "Large Floating Action") {
                HStack {
                    Label("Create Item", systemImage: "plus")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(.thinMaterial)
                        .clipShape(Capsule())
                    Spacer()
                }
            }

            // 5) Badge action - compact rounded rect consistent with scale
            Stage4Card(title: "Badge Action") {
                HStack {
                    Text("NEW")
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    Spacer()
                }
            }

            Stage4Observation(
                text: "Result: every control feels intentional. Sizes and corners follow a rhythm, touch targets are safer, and related controls visually belong together."
            )
        }
        .padding(16)
    }
}

private struct Stage4Header: View {
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08))
        .cornerRadius(12)
    }
}

private struct Stage4Card<Content: View>: View {
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

private struct Stage4Observation: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption2)
            .foregroundColor(.secondary)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.yellow.opacity(0.08))
            .cornerRadius(10)
    }
}

private struct Stage4Chip: View {
    let title: String
    let isSelected: Bool

    init(_ title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }

    var body: some View {
        Text(title)
            .font(.subheadline)
            .fontWeight(isSelected ? .semibold : .regular)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(isSelected ? Material.regular : Material.thin)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview("Stage 4 — Vibrant") {
    Stage4_ShapeGeometry()
}

#Preview("Stage 4 — Dark") {
    Stage4_ShapeGeometry()
        .preferredColorScheme(.dark)
}

#Preview("Stage 4 — Large Type") {
    Stage4_ShapeGeometry()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}
