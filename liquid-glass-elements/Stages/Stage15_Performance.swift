import SwiftUI

fileprivate enum Stage15_Mode: String, CaseIterable {
    case excessive = "Excessive"
    case optimized = "Optimized"
}

/// Stage 15 - Performance and rendering discipline
///
/// Objective: compare an intentionally heavy glass screen with a grouped,
/// simplified version so profiling has clear before/after behavior.
struct Stage15_Performance: View {
    @State private var mode: Stage15_Mode = .excessive
    @State private var selectedBackground: BackgroundSelection = .busy
    @State private var animate = false

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(0..<16, id: \.self) { index in
                        if mode == .excessive {
                            Stage15_HeavyCard(index: index, animate: animate)
                        } else {
                            Stage15_OptimizedCard(index: index, animate: animate)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 130)
                .padding(.bottom, 30)
            }

            VStack {
                Stage15_TopControls(mode: $mode, selectedBackground: $selectedBackground)
                Spacer()
            }
        }
        .onAppear {
            animate = true
        }
    }
}

private struct Stage15_TopControls: View {
    @Binding var mode: Stage15_Mode
    @Binding var selectedBackground: BackgroundSelection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 15 - Performance and rendering discipline")
                .font(.headline)

            Picker("Mode", selection: $mode) {
                ForEach(Stage15_Mode.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            Picker("Background", selection: $selectedBackground) {
                ForEach(BackgroundSelection.allCases, id: \.self) { bg in
                    Text(bg.label).tag(bg)
                }
            }
            .pickerStyle(.menu)

            Text(mode == .excessive
                 ? "Excessive: many unrelated glass layers + many independent animations."
                 : "Optimized: grouped controls, fewer glass layers, simpler animation.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

private struct Stage15_HeavyCard: View {
    let index: Int
    let animate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Heavy Scene \(index + 1)")
                    .font(.headline)
                Spacer()
                Image(systemName: "waveform.path.ecg")
                    .rotationEffect(.degrees(animate ? 360 : 0))
                    .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: animate)
            }

            Text("Many independent glass chips and animations increase rendering work.")
                .font(.caption)
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                Stage15_HeavyChip(title: "Like", symbol: "heart.fill", phase: animate)
                Stage15_HeavyChip(title: "Save", symbol: "bookmark.fill", phase: animate)
                Stage15_HeavyChip(title: "Share", symbol: "paperplane.fill", phase: animate)
            }

            HStack(spacing: 10) {
                Stage15_HeavyChip(title: "Mute", symbol: "speaker.slash.fill", phase: animate)
                Stage15_HeavyChip(title: "Pin", symbol: "pin.fill", phase: animate)
                Stage15_HeavyChip(title: "Flag", symbol: "flag.fill", phase: animate)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage15_OptimizedCard: View {
    let index: Int
    let animate: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Optimized Scene \(index + 1)")
                    .font(.headline)
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .scaleEffect(animate ? 1.03 : 1.0)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)
            }

            Text("Grouped actions reduce unrelated layers and improve coherence.")
                .font(.caption)
                .foregroundColor(.secondary)

            if #available(iOS 26, *) {
                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        Stage15_OptimizedChip(title: "Like", symbol: "heart.fill")
                        Stage15_OptimizedChip(title: "Save", symbol: "bookmark.fill")
                        Stage15_OptimizedChip(title: "Share", symbol: "paperplane.fill")
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .glassEffect(.regular.interactive(), in: Capsule())
                }
            } else {
                HStack(spacing: 8) {
                    Stage15_OptimizedChip(title: "Like", symbol: "heart.fill")
                    Stage15_OptimizedChip(title: "Save", symbol: "bookmark.fill")
                    Stage15_OptimizedChip(title: "Share", symbol: "paperplane.fill")
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Capsule().fill(.thinMaterial))
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage15_HeavyChip: View {
    let title: String
    let symbol: String
    let phase: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: symbol)
                .rotation3DEffect(.degrees(phase ? 18 : -18), axis: (x: 1, y: 0, z: 0))
                .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: phase)
            Text(title)
                .font(.caption2)
        }
        .foregroundColor(.primary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Stage15GlassSurface(shape: Capsule()))
    }
}

private struct Stage15_OptimizedChip: View {
    let title: String
    let symbol: String

    var body: some View {
        Label {
            Text(title)
                .font(.caption)
        } icon: {
            Image(systemName: symbol)
                .symbolRenderingMode(.monochrome)
                .font(.system(size: 15, weight: .bold))
                .frame(width: 16)
        }
        .labelStyle(.titleAndIcon)
        .foregroundStyle(.primary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
}

private struct Stage15GlassSurface<S: InsettableShape>: View {
    let shape: S

    var body: some View {
        if #available(iOS 26, *) {
            Color.clear
                .glassEffect(.regular.interactive(), in: shape)
        } else {
            shape.fill(.thinMaterial)
        }
    }
}

#Preview("Stage 15 - Excessive") {
    Stage15_Performance()
}

#Preview("Stage 15 - Dark") {
    Stage15_Performance()
        .preferredColorScheme(.dark)
}
