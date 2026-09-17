import SwiftUI

/// A reusable container for displaying incorrect vs. preferred implementations side-by-side.
struct ComparisonView<Content: View>: View {
    let incorrect: Content
    let preferred: Content
    let labels: (String, String)
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Stage 0: Material vs. Opaque Overlay")
                .font(.headline)
                .padding(.top, 16)
            
            HStack(spacing: 12) {
                // Incorrect version
                VStack(spacing: 8) {
                    Text(labels.0)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    ZStack {
                        Color.gray.opacity(0.2)
                        incorrect
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red.opacity(0.5), lineWidth: 2)
                    )
                }
                
                // Preferred version
                VStack(spacing: 8) {
                    Text(labels.1)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    ZStack {
                        Color.gray.opacity(0.2)
                        preferred
                    }
                    .frame(height: 300)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.green.opacity(0.5), lineWidth: 2)
                    )
                }
            }
            .padding(.horizontal, 12)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Key Differences:")
                    .font(.caption)
                    .fontWeight(.bold)
                
                BulletPoint("Opaque overlay is static; Material adapts to appearance")
                BulletPoint("Material responds to Reduce Transparency setting")
                BulletPoint("Material feels integrated; opaque feels 'pasted on'")
                BulletPoint("Material maintains legibility across backgrounds")
            }
            .font(.caption)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color(UIColor.systemBackground))
    }
}

// MARK: - Helper

private struct BulletPoint: View {
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
    }
}

#Preview {
    ComparisonView(
        incorrect: {
            VStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                Text("Incorrect")
                    .font(.caption)
            }
            .foregroundColor(.white)
        }(),
        preferred: {
            VStack {
                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                Text("Preferred")
                    .font(.caption)
            }
            .foregroundColor(.primary)
        }(),
        labels: ("Opaque (wrong)", "Material (better)")
    )
}
