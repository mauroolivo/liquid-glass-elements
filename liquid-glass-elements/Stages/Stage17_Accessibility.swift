import SwiftUI

fileprivate enum Stage17_Implementation: String, CaseIterable {
    case incorrect = "Incorrect"
    case fixed = "Fixed"
}

/// Stage 17 - Accessibility and environmental adaptation
///
/// Objective: compare a custom glass control that fails accessibility checks
/// with a refactored version that adapts to motion, contrast, and touch size.
struct Stage17_Accessibility: View {
    @State private var implementation: Stage17_Implementation = .incorrect
    @State private var selectedBackground: BackgroundSelection = .busy
    @State private var isArmed = false
    @State private var simulateReduceMotion = false

    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var effectiveReduceMotion: Bool {
        simulateReduceMotion || systemReduceMotion
    }

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 12) {
                    Stage17_ControlCard(
                        implementation: implementation,
                        isArmed: $isArmed,
                        reduceMotion: effectiveReduceMotion,
                        dynamicTypeSize: dynamicTypeSize
                    )

                    Stage17_ChecklistCard(implementation: implementation)
                }
                .padding(.horizontal, 16)
                .padding(.top, 150)
                .padding(.bottom, 24)
            }

            VStack {
                Stage17_Controls(
                    implementation: $implementation,
                    selectedBackground: $selectedBackground,
                    simulateReduceMotion: $simulateReduceMotion,
                    systemReduceMotion: systemReduceMotion
                )
                Spacer()
            }
        }
    }
}

private struct Stage17_Controls: View {
    @Binding var implementation: Stage17_Implementation
    @Binding var selectedBackground: BackgroundSelection
    @Binding var simulateReduceMotion: Bool
    let systemReduceMotion: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 17 - Accessibility and adaptation")
                .font(.headline)

            Picker("Implementation", selection: $implementation) {
                ForEach(Stage17_Implementation.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)

            Toggle("Simulate Reduce Motion", isOn: $simulateReduceMotion)
                .font(.caption)

            Picker("Background", selection: $selectedBackground) {
                ForEach(BackgroundSelection.allCases, id: \.self) { bg in
                    Text(bg.label).tag(bg)
                }
            }
            .pickerStyle(.menu)

            Text(systemReduceMotion
                 ? "System Reduce Motion is ON."
                 : "System Reduce Motion is OFF.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

private struct Stage17_ControlCard: View {
    let implementation: Stage17_Implementation
    @Binding var isArmed: Bool
    let reduceMotion: Bool
    let dynamicTypeSize: DynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(implementation == .incorrect ? "Incorrect Control" : "Refactored Control")
                    .font(.headline)
                Spacer()
                Text(isArmed ? "ARMED" : "IDLE")
                    .font(.caption)
                    .foregroundColor(isArmed ? .red : .secondary)
            }

            Text(implementation == .incorrect
                 ? "Small target, color-only state, and animation ignores motion preferences."
                 : "44pt target, explicit label, contrast-aware, and animation respects Reduce Motion.")
                .font(.caption)
                .foregroundColor(.secondary)

            if implementation == .incorrect {
                incorrectControl
            } else {
                fixedControl
            }

            Text("Dynamic Type: \(dynamicTypeSize.description)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var incorrectControl: some View {
        Button {
            isArmed.toggle()
        } label: {
            Circle()
                .fill(isArmed ? Color.red.opacity(0.75) : Color.green.opacity(0.75))
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
                .scaleEffect(isArmed ? 1.08 : 0.92)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isArmed)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Toggle")
    }

    private var fixedControl: some View {
        Button {
            isArmed.toggle()
        } label: {
            Label(isArmed ? "Recording armed" : "Recording idle", systemImage: isArmed ? "record.circle.fill" : "record.circle")
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
                .frame(minWidth: 44, minHeight: 44)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(fixedSurface)
                .scaleEffect(reduceMotion ? 1.0 : (isArmed ? 1.03 : 1.0))
                .animation(reduceMotion ? .none : .easeInOut(duration: 0.24), value: isArmed)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Double tap to toggle recording arm state")
    }

    @ViewBuilder
    private var fixedSurface: some View {
        if #available(iOS 26, *) {
            Color.clear
                .glassEffect(.regular.interactive(), in: Capsule())
        } else {
            Capsule().fill(.thinMaterial)
        }
    }
}

private struct Stage17_ChecklistCard: View {
    let implementation: Stage17_Implementation

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Accessibility Audit")
                .font(.headline)

            if implementation == .incorrect {
                checklistLine("Touch target under 44pt", false)
                checklistLine("Meaning relies only on color", false)
                checklistLine("Animation respects Reduce Motion", false)
                checklistLine("Label describes state", false)
            } else {
                checklistLine("Touch target at least 44pt", true)
                checklistLine("Meaning not color-only", true)
                checklistLine("Animation respects Reduce Motion", true)
                checklistLine("Label describes state", true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func checklistLine(_ text: String, _ passed: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(passed ? .green : .red)
            Text(text)
                .font(.caption)
        }
    }
}

private extension DynamicTypeSize {
    var description: String {
        switch self {
        case .xSmall: return "xSmall"
        case .small: return "small"
        case .medium: return "medium"
        case .large: return "large"
        case .xLarge: return "xLarge"
        case .xxLarge: return "xxLarge"
        case .xxxLarge: return "xxxLarge"
        case .accessibility1: return "AX1"
        case .accessibility2: return "AX2"
        case .accessibility3: return "AX3"
        case .accessibility4: return "AX4"
        case .accessibility5: return "AX5"
        @unknown default: return "unknown"
        }
    }
}

#Preview("Stage 17 - Incorrect") {
    Stage17_Accessibility()
}

#Preview("Stage 17 - Dark") {
    Stage17_Accessibility()
        .preferredColorScheme(.dark)
}

#Preview("Stage 17 - Large Type") {
    Stage17_Accessibility()
        .environment(\.dynamicTypeSize, .accessibility3)
}
