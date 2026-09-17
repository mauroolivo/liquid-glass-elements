import SwiftUI

/// Stage 3 — First Custom Glass Effect
///
/// Objective: Understand the `glassEffect()` API and how it differs from `Material`.
/// `Material` is static blur + opacity. `glassEffect()` is contextual rendering that
/// responds to underlying content, light, and interaction.
///
/// Mental model: glassEffect() > Material. Use it for custom control surfaces.

struct Stage3_FirstCustomGlass: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var selectedShape: GlassShape = .roundedRectangle
    @State private var showComparison: Bool = true
    
    var body: some View {
        ZStack {
            // Background
            selectedBackground.backgroundContent.view()
            
            // Main content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Stage 3: First Custom Glass Effect")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("glassEffect() vs. Material background")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)
                
                // Main content
                ScrollView {
                    if showComparison {
                        ComparisonContent(selectedShape: selectedShape)
                    } else {
                        InteractiveTestContent(selectedShape: selectedShape)
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
                            ForEach(BackgroundSelection.allCases, id: \.self) { bg in
                                Text(bg.label).tag(bg)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Glass Shape:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Picker("Shape", selection: $selectedShape) {
                            ForEach(GlassShape.allCases, id: \.self) { shape in
                                Text(shape.label).tag(shape)
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
                    
                    Text("Compare Material vs. glassEffect() on different backgrounds and shapes.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

// MARK: - Glass Shape Selection

enum GlassShape: String, CaseIterable {
    case roundedRectangle
    case capsule
    case circle
    
    var label: String {
        switch self {
        case .roundedRectangle: "Rounded Rectangle"
        case .capsule: "Capsule"
        case .circle: "Circle"
        }
    }
}

// MARK: - Comparison Content

struct ComparisonContent: View {
    let selectedShape: GlassShape
    
    var body: some View {
        VStack(spacing: 16) {
            // Explanation
            VStack(spacing: 12) {
                Text("Understanding the Difference")
                    .font(.headline)
                
                Text("Both Material and glassEffect() provide frosted glass-like appearance, but they work differently:")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            // Material explanation
            VStack(spacing: 12) {
                VStack {
                    Text("Material Background")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                VStack(spacing: 12) {
                    // Material button
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                        Text("Favorite")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .background(Material.thin)
                    .clipShape(selectedShape.shape())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Characteristics:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        BulletPointText("• Static blur + opacity")
                        BulletPointText("• Doesn't adapt to content")
                        BulletPointText("• Same appearance everywhere")
                        BulletPointText("• More performant")
                        BulletPointText("• Good for simple surfaces")
                    }
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.blue.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.blue.opacity(0.02))
            .cornerRadius(12)
            
            // glassEffect explanation (iOS 18+)
            VStack(spacing: 12) {
                VStack {
                    Text("glassEffect() (iOS 18+)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(8)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                VStack(spacing: 12) {
                    // glassEffect button - preview of what it looks like
                    VStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                        Text("Favorite")
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(20)
                    .stage3GlassSurface(in: selectedShape.shape())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Characteristics:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        BulletPointText("• Contextual rendering")
                        BulletPointText("• Adapts to content beneath")
                        BulletPointText("• Responsive to interaction")
                        BulletPointText("• More sophisticated")
                        BulletPointText("• Better for immersive controls")
                    }
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(Color.green.opacity(0.05))
                    .cornerRadius(8)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.green.opacity(0.02))
            .cornerRadius(12)
            
            // Conclusion
            VStack(spacing: 8) {
                Text("Observation")
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text("On complex, busy, or colorful backgrounds, glassEffect() should adapt more intelligently to the underlying content, maintaining better separation and legibility. Toggle the background to observe.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color.yellow.opacity(0.05))
            .cornerRadius(12)
        }
        .padding(16)
    }
}

struct InteractiveTestContent: View {
    @State private var isFavorited = false
    let selectedShape: GlassShape
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Interactive Test")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
            
            // Material version
            VStack(spacing: 12) {
                Text("Material.thin")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                Button(action: { isFavorited.toggle() }) {
                    VStack {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 32))
                        Text(isFavorited ? "Favorited" : "Favorite")
                            .font(.headline)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .background(Material.thin)
                    .clipShape(selectedShape.shape())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.blue.opacity(0.02))
            .cornerRadius(12)
            
            // glassEffect-like version (using thicker material as preview)
            VStack(spacing: 12) {
                Text("glassEffect() Preview (iOS 18+)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                Button(action: { isFavorited.toggle() }) {
                    VStack {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 32))
                        Text(isFavorited ? "Favorited" : "Favorite")
                            .font(.headline)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(32)
                    .stage3GlassSurface(in: selectedShape.shape())
                }
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.green.opacity(0.02))
            .cornerRadius(12)
            
            Text("Tap both buttons and compare their feel. In iOS 18+, glassEffect() provides more intelligent rendering that adapts to the content beneath.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .padding(16)
        }
        .padding(16)
    }
}

// MARK: - Shape Extensions

extension GlassShape {
    func shape() -> AnyShape {
        switch self {
        case .roundedRectangle:
            AnyShape(RoundedRectangle(cornerRadius: 12))
        case .capsule:
            AnyShape(Capsule())
        case .circle:
            AnyShape(Circle())
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .roundedRectangle: 12
        case .capsule: 20
        case .circle: 0
        }
    }
}

private extension View {
    @ViewBuilder
    func stage3GlassSurface(in shape: AnyShape) -> some View {
        if #available(iOS 18, *) {
            self
                .glassEffect()
                .clipShape(shape)
        } else {
            self
                .background(Material.regular)
                .clipShape(shape)
        }
    }
}

// MARK: - Previews

#Preview("Stage 3 — Vibrant Background") {
    Stage3_FirstCustomGlass()
}

#Preview("Stage 3 — Dark Mode") {
    Stage3_FirstCustomGlass()
        .preferredColorScheme(.dark)
}

#Preview("Stage 3 — Large Type") {
    Stage3_FirstCustomGlass()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 3 — Reduce Transparency") {
    Stage3_FirstCustomGlass()
        .preferredColorScheme(.light)
}
