import SwiftUI

fileprivate enum Stage11_5_MotionMode: String, CaseIterable {
    case incorrect = "Incorrect"
    case preferred = "Preferred"
}

/// Stage 11.5 - Glass lens motion
///
/// Objective: Explore motion-driven glass behavior and compare overdone motion
/// with restrained motion that respects Reduce Motion.
struct Stage11_5_GlassLensMotion: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var mode: Stage11_5_MotionMode = .preferred
    @State private var scrollOffset: CGFloat = 0
    @GestureState private var dragTranslation: CGSize = .zero
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: Stage11_5_ScrollOffsetKey.self,
                            value: proxy.frame(in: .named("stage11_5_scroll")).minY
                        )
                }
                .frame(height: 0)

                VStack(spacing: 12) {
                    ForEach(0..<14, id: \.self) { index in
                        Stage11_5_ContentCard(index: index)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 96)
                .padding(.bottom, 24)
            }
            .coordinateSpace(name: "stage11_5_scroll")
            .onPreferenceChange(Stage11_5_ScrollOffsetKey.self) { value in
                scrollOffset = value
            }

            .overlay(alignment: .top) {
                Stage11_5_MotionLens(
                    mode: mode,
                    scrollOffset: scrollOffset,
                    dragX: dragTranslation.width,
                    reduceMotion: reduceMotion
                )
                .padding(.top, 12)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($dragTranslation) { value, state, _ in
                            state = value.translation
                        }
                )
            }

            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Stage 11.5 - Glass Lens Motion")
                        .font(.headline)

                    Picker("Mode", selection: $mode) {
                        ForEach(Stage11_5_MotionMode.allCases, id: \.self) { option in
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

                    Text(mode == .incorrect
                         ? "Incorrect: exaggerated lens motion and no motion restraint."
                         : "Preferred: subtle lens motion and accessibility-aware behavior.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

private struct Stage11_5_MotionLens: View {
    let mode: Stage11_5_MotionMode
    let scrollOffset: CGFloat
    let dragX: CGFloat
    let reduceMotion: Bool

    private var normalizedScroll: CGFloat {
        let clamped = max(-140, min(140, -scrollOffset))
        return clamped / 140
    }

    private var normalizedDrag: CGFloat {
        let clamped = max(-120, min(120, dragX))
        return clamped / 120
    }

    private var motionX: CGFloat {
        if reduceMotion { return 0 }
        switch mode {
        case .incorrect:
            return (normalizedDrag * 46) + (normalizedScroll * 20)
        case .preferred:
            return (normalizedDrag * 10) + (normalizedScroll * 4)
        }
    }

    private var motionY: CGFloat {
        if reduceMotion { return 0 }
        switch mode {
        case .incorrect:
            return abs(normalizedDrag) * -16
        case .preferred:
            return abs(normalizedDrag) * -4
        }
    }

    private var rotation: Double {
        if reduceMotion { return 0 }
        switch mode {
        case .incorrect:
            return Double(normalizedDrag * 18)
        case .preferred:
            return Double(normalizedDrag * 4)
        }
    }

    var body: some View {
        HStack(spacing: 8) {
            Label("Lens", systemImage: "camera.metering.center.weighted")
            Text(mode == .incorrect ? "Overdone" : "Restrained")
                .fontWeight(.semibold)
        }
        .font(.subheadline)
        .foregroundColor(.primary)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(lensBackground)
        .overlay(
            Capsule(style: .continuous)
                .stroke(
                    mode == .incorrect ? Color.red.opacity(0.75) : Color.accentColor.opacity(0.35),
                    lineWidth: mode == .incorrect ? 2 : 1
                )
        )
        .scaleEffect(mode == .incorrect ? 1.08 : 1.0)
        .offset(y: mode == .incorrect ? 2 : 0)
        .offset(x: motionX, y: motionY)
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .animation(reduceMotion ? .easeOut(duration: 0.12) : .spring(response: 0.22, dampingFraction: 0.78), value: motionX)
        .accessibilityLabel("Lens motion sample")
    }

    @ViewBuilder
    private var lensBackground: some View {
        if #available(iOS 26, *) {
            Color.clear
                .glassEffect(.regular.interactive(), in: Capsule())
        } else {
            Capsule()
                .fill(.thinMaterial)
        }
    }
}

private struct Stage11_5_ContentCard: View {
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Scene \(index + 1)")
                .font(.caption)
                .foregroundColor(.secondary)

            Text("Motion should support orientation, not distract from content.")
                .font(.headline)

            Text("Drag horizontally and scroll vertically. Compare exaggerated movement with restrained movement.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

private struct Stage11_5_ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview("Stage 11.5 - Portrait") {
    Stage11_5_GlassLensMotion()
}

#Preview("Stage 11.5 - Dark") {
    Stage11_5_GlassLensMotion()
        .preferredColorScheme(.dark)
}

#Preview("Stage 11.5 - Reduce Motion") {
    Stage11_5_GlassLensMotion()
}
