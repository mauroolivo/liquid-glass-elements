import SwiftUI

/// Stage 0 — Liquid Glass Laboratory
///
/// Objective: Prepare a controlled environment for studying glass.
/// Create a minimal SwiftUI application with visually rich backgrounds
/// that make glass behavior obvious.
///
/// This stage does NOT apply custom Liquid Glass yet.
/// The goal is environment preparation and comparison infrastructure.

struct Stage0_Laboratory: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var showComparison: Bool = true
    
    var body: some View {
        ZStack {
            // Background
            selectedBackground.backgroundContent.view()
            
            // Main content
            VStack(spacing: 0) {
                // Header with background selector
                VStack(spacing: 8) {
                    Text("Stage 0: Liquid Glass Laboratory")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Testing material vs. opaque backgrounds")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)
                
                if showComparison {
                    // Comparison view
                    ScrollView {
                        ComparisonViewContent()
                            .padding(16)
                    }
                } else {
                    // Interactive test view
                    InteractiveTestView(background: selectedBackground)
                }
                
                // Footer with controls
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
                        Text("View Mode:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Picker("Mode", selection: $showComparison) {
                            Text("Side-by-side").tag(true)
                            Text("Interactive").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Text("Toggle the background selector to observe how Material adapts while opaque overlay remains static.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

// MARK: - Background Selection

enum BackgroundSelection: String, CaseIterable {
    case vibrant
    case highContrast
    case neutral
    case busy
    case light
    case dark
    
    var label: String {
        switch self {
        case .vibrant: "Vibrant (Purple→Green)"
        case .highContrast: "High Contrast"
        case .neutral: "Neutral Gray"
        case .busy: "Busy Pattern"
        case .light: "Light (White)"
        case .dark: "Dark (Black)"
        }
    }
    
    var backgroundContent: BackgroundContent {
        switch self {
        case .vibrant: .vibrant
        case .highContrast: .highContrast
        case .neutral: .neutral
        case .busy: .busy
        case .light: .lightContent
        case .dark: .darkContent
        }
    }
}

// MARK: - Comparison View Content

struct ComparisonViewContent: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Opaque Overlay vs. Material Background")
                .font(.headline)
            
            HStack(spacing: 16) {
                // INCORRECT: Opaque overlay
                VStack(spacing: 12) {
                    VStack {
                        Text("INCORRECT")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                        
                        Text("Opaque Overlay")
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                    
                    VStack(spacing: 12) {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20))
                            Text("Favorite")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.5)) // INCORRECT: Opaque, doesn't adapt
                        .cornerRadius(12)
                        
                        VStack(spacing: 4) {
                            Text("Problems:")
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            Text("• Static color")
                                .font(.caption2)
                            
                            Text("• Doesn't adapt to appearance")
                                .font(.caption2)
                            
                            Text("• Illegible on some backgrounds")
                                .font(.caption2)
                            
                            Text("• Looks 'pasted on'")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption2)
                        .padding(8)
                        .background(Color.red.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
                
                // PREFERRED: Material background
                VStack(spacing: 12) {
                    VStack {
                        Text("PREFERRED")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                        
                        Text("Material Background")
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                    
                    VStack(spacing: 12) {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 20))
                            Text("Favorite")
                                .font(.caption)
                        }
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Material.thin) // CORRECT: Adapts to environment
                        .cornerRadius(12)
                        
                        VStack(spacing: 4) {
                            Text("Benefits:")
                                .font(.caption)
                                .fontWeight(.bold)
                            
                            Text("• Adapts to appearance")
                                .font(.caption2)
                            
                            Text("• System-managed")
                                .font(.caption2)
                            
                            Text("• Legible everywhere")
                                .font(.caption2)
                            
                            Text("• Feels integrated")
                                .font(.caption2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.caption2)
                        .padding(8)
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(8)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("How to Test:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                BulletPointText("Switch to Light or Dark mode (swipe up to Control Center)")
                BulletPointText("Use a busy pattern — notice Material maintains legibility")
                BulletPointText("Enable Reduce Transparency (Settings → Accessibility → Display & Text Size)")
                BulletPointText("Observe that Material adapts; opaque overlay does not")
            }
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

// MARK: - Interactive Test View

struct InteractiveTestView: View {
    let background: BackgroundSelection
    @State private var isOpaquePressed = false
    @State private var isMaterialPressed = false
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            VStack(spacing: 20) {
                Text("Tap to test interaction")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 20) {
                    // Opaque button
                    VStack(spacing: 12) {
                        Button(action: { isOpaquePressed.toggle() }) {
                            VStack {
                                Image(systemName: isOpaquePressed ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                Text("Opaque")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(12)
                        }
                        
                        Text("Static")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    // Material button
                    VStack(spacing: 12) {
                        Button(action: { isMaterialPressed.toggle() }) {
                            VStack {
                                Image(systemName: isMaterialPressed ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                Text("Material")
                                    .font(.caption)
                            }
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Material.thin)
                            .cornerRadius(12)
                        }
                        
                        Text("Adaptive")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(20)
            
            Spacer()
        }
    }
}

// MARK: - Helper Views

struct BulletPointText: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Text("•")
                .fontWeight(.bold)
            Text(text)
        }
        .font(.caption2)
    }
}

// MARK: - Previews

#Preview("Stage 0 — Vibrant Background") {
    Stage0_Laboratory()
}

#Preview("Stage 0 — Dark Mode") {
    Stage0_Laboratory()
        .preferredColorScheme(.dark)
}

#Preview("Stage 0 — Large Type") {
    Stage0_Laboratory()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 0 — Reduce Transparency") {
    Stage0_Laboratory()
        .preferredColorScheme(.light)
}
