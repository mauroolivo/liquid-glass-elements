import SwiftUI

fileprivate enum Stage16_Pattern: String, CaseIterable {
    case glassEverywhere = "Glass Everywhere"
    case glassContentCards = "Glass Content Cards"
    case tinyTargets = "Tiny Touch Targets"
    case excessiveTint = "Excessive Tint"

    var shortDiagnosis: String {
        switch self {
        case .glassEverywhere:
            return "If everything is elevated, nothing is elevated."
        case .glassContentCards:
            return "Content becomes noisy when passive cards are glass by default."
        case .tinyTargets:
            return "Visual style cannot compensate for poor hit area size."
        case .excessiveTint:
            return "Strong tint on every action destroys semantic hierarchy."
        }
    }
}

fileprivate enum Stage16_Implementation: String, CaseIterable {
    case incorrect = "Incorrect"
    case preferred = "Refactored"
}

/// Stage 16 - Liquid Glass anti-pattern audit
///
/// Objective: inspect recurring anti-patterns, ask diagnostic questions,
/// and compare a refactored implementation for each case.
struct Stage16_AntiPatterns: View {
    @State private var selectedPattern: Stage16_Pattern = .glassEverywhere
    @State private var implementation: Stage16_Implementation = .incorrect
    @State private var selectedBackground: BackgroundSelection = .busy

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 14) {
                    Stage16_PreviewCard(pattern: selectedPattern, implementation: implementation)
                    Stage16_DiagnosticCard(pattern: selectedPattern)
                }
                .padding(.horizontal, 16)
                .padding(.top, 160)
                .padding(.bottom, 24)
            }

            VStack {
                Stage16_Controls(
                    selectedPattern: $selectedPattern,
                    implementation: $implementation,
                    selectedBackground: $selectedBackground
                )
                Spacer()
            }
        }
    }
}

private struct Stage16_Controls: View {
    @Binding var selectedPattern: Stage16_Pattern
    @Binding var implementation: Stage16_Implementation
    @Binding var selectedBackground: BackgroundSelection

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 16 - Liquid Glass anti-pattern audit")
                .font(.headline)

            Picker("Pattern", selection: $selectedPattern) {
                ForEach(Stage16_Pattern.allCases, id: \.self) { pattern in
                    Text(pattern.rawValue).tag(pattern)
                }
            }
            .pickerStyle(.menu)

            Picker("Implementation", selection: $implementation) {
                ForEach(Stage16_Implementation.allCases, id: \.self) { option in
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

            Text(selectedPattern.shortDiagnosis)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

private struct Stage16_PreviewCard: View {
    let pattern: Stage16_Pattern
    let implementation: Stage16_Implementation

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(pattern.rawValue)
                    .font(.headline)
                Spacer()
                Text(implementation.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            switch pattern {
            case .glassEverywhere:
                stageGlassEverywhere
            case .glassContentCards:
                stageGlassContentCards
            case .tinyTargets:
                stageTinyTargets
            case .excessiveTint:
                stageExcessiveTint
            }
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    private var stageGlassEverywhere: some View {
        VStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { index in
                Text("Card \(index + 1) - Editorial content")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .modifier(Stage16_GlassIfNeeded(enabled: implementation == .incorrect))
            }

            HStack(spacing: 8) {
                Stage16_ActionChip(title: "Open", style: implementation == .incorrect ? .glass : .plain)
                Stage16_ActionChip(title: "Save", style: .glass)
                Stage16_ActionChip(title: "Share", style: .glass)
            }
        }
    }

    @ViewBuilder
    private var stageGlassContentCards: some View {
        VStack(spacing: 10) {
            ForEach(0..<2, id: \.self) { index in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Article \(index + 1)")
                        .font(.headline)
                    Text("In the refactor, content cards are plain surfaces and only controls use glass.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(implementation == .incorrect ? AnyShapeStyle(.thinMaterial) : AnyShapeStyle(Color.secondary.opacity(0.10)))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            HStack {
                Spacer()
                Stage16_ActionChip(title: "Primary Action", style: .glass)
            }
        }
    }

    @ViewBuilder
    private var stageTinyTargets: some View {
        HStack(spacing: 12) {
            if implementation == .incorrect {
                ForEach(["plus", "heart", "paperplane"], id: \.self) { symbol in
                    Image(systemName: symbol)
                        .font(.caption)
                        .padding(6)
                        .modifier(Stage16_GlassIfNeeded(enabled: true, cornerRadius: 8))
                }
            } else {
                ForEach(["plus", "heart", "paperplane"], id: \.self) { symbol in
                    Image(systemName: symbol)
                        .font(.body)
                        .frame(minWidth: 44, minHeight: 44)
                        .modifier(Stage16_GlassIfNeeded(enabled: true, cornerRadius: 12))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var stageExcessiveTint: some View {
        HStack(spacing: 8) {
            Stage16_ActionChip(title: "Play", style: .glass, tint: implementation == .incorrect ? .pink : nil)
            Stage16_ActionChip(title: "Save", style: .glass, tint: implementation == .incorrect ? .orange : nil)
            Stage16_ActionChip(title: "Delete", style: .glass, tint: implementation == .incorrect ? .red : .red)
        }
        .foregroundColor(implementation == .incorrect ? .white : .primary)
    }
}

private struct Stage16_DiagnosticCard: View {
    let pattern: Stage16_Pattern

    private let auditQuestions: [String] = [
        "What problem was the developer trying to solve?",
        "Does glass communicate hierarchy?",
        "Is this control or content?",
        "Could a normal surface work better?",
        "Could a system component solve it?",
        "Does the material have meaningful content underneath?",
        "Is interaction clear?",
        "Is accessibility preserved?"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Audit Questions")
                .font(.headline)

            ForEach(auditQuestions, id: \.self) { question in
                Text("- \(question)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Focus for this pattern: \(pattern.shortDiagnosis)")
                .font(.caption)
                .foregroundColor(.primary)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private enum Stage16_ChipStyle {
    case plain
    case glass
}

private struct Stage16_ActionChip: View {
    let title: String
    let style: Stage16_ChipStyle
    var tint: Color? = nil

    var body: some View {
        Text(title)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(chipBackground)
            .clipShape(Capsule(style: .continuous))
    }

    @ViewBuilder
    private var chipBackground: some View {
        if let tint {
            tint.opacity(0.75)
        } else {
            switch style {
            case .plain:
                Color.secondary.opacity(0.12)
            case .glass:
                if #available(iOS 26, *) {
                    Color.clear.glassEffect(.regular.interactive(), in: Capsule())
                } else {
                    Capsule().fill(.thinMaterial)
                }
            }
        }
    }
}

private struct Stage16_GlassIfNeeded: ViewModifier {
    let enabled: Bool
    var cornerRadius: CGFloat = 10

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            if #available(iOS 26, *) {
                content
                    .background(Color.clear.glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)))
            } else {
                content
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
        } else {
            content
                .background(Color.secondary.opacity(0.10))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }
}

#Preview("Stage 16 - Anti Patterns") {
    Stage16_AntiPatterns()
}

#Preview("Stage 16 - Dark") {
    Stage16_AntiPatterns()
        .preferredColorScheme(.dark)
}
