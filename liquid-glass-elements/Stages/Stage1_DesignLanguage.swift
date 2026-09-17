import SwiftUI

/// Stage 1 — Understand the Liquid Glass Design Language
///
/// Objective: Learn why strategic glass improves hierarchy better than glass-everywhere.
/// Build a deliberately incorrect interface with glass on everything, then refactor to
/// the preferred version using glass only for control/navigation elements.
///
/// Mental model: Glass should CLARIFY hierarchy, not FLATTEN everything into the same material.

struct Stage1_DesignLanguage: View {
    @State private var selectedBackground: Stage1_BackgroundSelection = .vibrant
    @State private var showPreferred: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            selectedBackground.backgroundContent.view()
            
            // Main content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Stage 1: Glass Design Language")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Strategic glass vs. Glass everywhere")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)
                
                // Main content
                ScrollView {
                    if showPreferred {
                        PreferredImplementation()
                    } else {
                        IncorrectImplementation()
                    }
                }
                
                // Footer with controls
                VStack(spacing: 12) {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Test Background:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Picker("Background", selection: $selectedBackground) {
                            ForEach(Stage1_BackgroundSelection.allCases, id: \.self) { bg in
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
                            Text("❌ Incorrect (Glass Everywhere)").tag(false)
                            Text("✅ Preferred (Strategic Glass)").tag(true)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Text("Toggle between implementations to observe: does hierarchy become clearer with strategic glass?")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

// MARK: - Incorrect Implementation: Glass Everywhere

struct IncorrectImplementation: View {
    var body: some View {
        VStack(spacing: 12) {
            // Incorrect header
            VStack(spacing: 12) {
                Text("❌ INCORRECT: Glass Everywhere")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("Why this fails:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 6) {
                    BulletPointText("• Every surface is elevated")
                    BulletPointText("• No hierarchy distinction")
                    BulletPointText("• Content blends with controls")
                    BulletPointText("• Looks noisy and confusing")
                }
                .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Material.thin)
            .cornerRadius(12)
            
            Divider()
            
            // Incorrect: Article card (should be content, not glass)
            VStack(alignment: .leading, spacing: 8) {
                Text("Article Title Goes Here")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Material.thin)  // WRONG: Content shouldn't be in glass
            .cornerRadius(12)
            
            // Incorrect: Another content card (glass again)
            VStack(alignment: .leading, spacing: 8) {
                Text("Another Article")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Material.thin)  // WRONG: Same visual treatment for content
            .cornerRadius(12)
            
            // Incorrect: Footer content (glass for content?)
            VStack(alignment: .leading, spacing: 4) {
                Text("Footer Information")
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text("This is just metadata or footer text. Why is it in glass?")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Material.thin)  // WRONG: Footer is content, not control
            .cornerRadius(12)
            
            // Incorrect: Action buttons (all prominent, all in glass)
            VStack(spacing: 8) {
                Button(action: {}) {
                    Label("Action 1", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(Material.regular)
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Label("Action 2", systemImage: "heart.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(Material.regular)
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Label("Action 3", systemImage: "share.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(Material.regular)
                        .cornerRadius(8)
                }
                
                Button(action: {}) {
                    Label("Action 4", systemImage: "trash.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(Material.regular)
                        .cornerRadius(8)
                }
            }
            .padding(12)
            .background(Material.thin)  // WRONG: Button group all in glass
            .cornerRadius(12)
            
            Text("Observation: Everything looks the same. Where should you look first? What is the primary action? The interface is visually noisy because nothing is elevated relative to anything else.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.red.opacity(0.05))
                .cornerRadius(8)
        }
        .padding(16)
    }
}

// MARK: - Preferred Implementation: Strategic Glass

struct PreferredImplementation: View {
    @State private var isStarred = false
    @State private var isFavorited = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Preferred header
            VStack(spacing: 12) {
                Text("✅ PREFERRED: Strategic Glass")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text("Why this works:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 6) {
                    BulletPointText("• Clear hierarchy")
                    BulletPointText("• Content on solid background")
                    BulletPointText("• Glass only on controls")
                    BulletPointText("• Feels organized")
                }
                .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.green.opacity(0.05))
            .cornerRadius(12)
            
            Divider()
            
            // Preferred: Article card (plain content, no glass)
            VStack(alignment: .leading, spacing: 8) {
                Text("Article Title Goes Here")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Text("Read more →")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(.systemBackground).opacity(0.8))  // CORRECT: Plain content background
            .cornerRadius(12)
            
            // Preferred: Another content card (consistent with first)
            VStack(alignment: .leading, spacing: 8) {
                Text("Another Article")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                
                Text("Read more →")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color(.systemBackground).opacity(0.8))  // CORRECT: Same content treatment
            .cornerRadius(12)
            
            // Preferred: Footer (plain text, no special treatment)
            VStack(alignment: .leading, spacing: 4) {
                Text("Footer Information")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("This is just metadata or footer text. It's content, not interactive.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            
            // Preferred: Control group (strategic glass for actions only)
            VStack(spacing: 8) {
                Text("Primary Action")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { isStarred.toggle() }) {
                    Label(isStarred ? "Starred" : "Star This", systemImage: "star.fill")
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(.primary)
                        .background(Material.thin)  // CORRECT: Glass only for primary action
                        .cornerRadius(8)
                }
                
                Text("Secondary Actions")
                    .font(.caption)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 4)
                
                HStack(spacing: 8) {
                    Button(action: { isFavorited.toggle() }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.primary)
                            .background(Material.thin)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.primary)
                            .background(Material.thin)
                            .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.primary)
                            .background(Material.thin)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemBackground).opacity(0.8))  // CORRECT: Control group has light background
            .cornerRadius(12)
            
            Text("Observation: Hierarchy is clear. Content is readable. Control glass is elevated and purposeful. Your eye naturally moves from content to actions. The interface feels organized and efficient.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(12)
                .background(Color.green.opacity(0.05))
                .cornerRadius(8)
        }
        .padding(16)
    }
}

// MARK: - Background Selection (Stage-specific)

enum Stage1_BackgroundSelection: String, CaseIterable {
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

// MARK: - Previews

#Preview("Stage 1 — Vibrant Background") {
    Stage1_DesignLanguage()
}

#Preview("Stage 1 — Dark Mode") {
    Stage1_DesignLanguage()
        .preferredColorScheme(.dark)
}

#Preview("Stage 1 — Large Type") {
    Stage1_DesignLanguage()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 1 — Reduce Transparency") {
    Stage1_DesignLanguage()
        .preferredColorScheme(.light)
}
