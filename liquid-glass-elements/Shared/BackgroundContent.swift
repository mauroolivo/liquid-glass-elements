import SwiftUI

/// Reusable background environment for testing glass across different contexts.
enum BackgroundContent {
    case photo(imageName: String)
    case gradient(Color, Color)
    case solid(Color)
    case busy(Color, Color)
    case moving
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .photo(let name):
            Image(name)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
        case .gradient(let c1, let c2):
            LinearGradient(
                gradient: Gradient(colors: [c1, c2]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
        case .solid(let color):
            color
                .ignoresSafeArea()
            
        case .busy(let fg, let bg):
            // Checkerboard pattern for testing
            Canvas { context, size in
                let tileSize: CGFloat = 20
                for x in stride(from: 0, through: size.width, by: tileSize) {
                    for y in stride(from: 0, through: size.height, by: tileSize) {
                        if (Int(x / tileSize) + Int(y / tileSize)) % 2 == 0 {
                            context.fill(
                                Path(CGRect(x: x, y: y, width: tileSize, height: tileSize)),
                                with: .color(fg)
                            )
                        } else {
                            context.fill(
                                Path(CGRect(x: x, y: y, width: tileSize, height: tileSize)),
                                with: .color(bg)
                            )
                        }
                    }
                }
            }
            .ignoresSafeArea()
            
        case .moving:
            // Animated gradient for testing adaptation over time
            TimelineView(.animation) { timeline in
                let phase = timeline.date.timeIntervalSince1970
                    .truncatingRemainder(dividingBy: 4.0) / 4.0
                
                AngularGradient(
                    gradient: Gradient(colors: [
                        .red,
                        .yellow,
                        .green,
                        .blue,
                        .purple,
                        .red
                    ]),
                    center: .center,
                    angle: .radians(.pi * 2 * phase)
                )
                .ignoresSafeArea()
            }
        }
    }
}

// MARK: - Convenience presets

extension BackgroundContent {
    /// High-contrast background for testing legibility
    static let highContrast = BackgroundContent.gradient(.black, .white)
    
    /// Vibrant gradient for testing over saturated backgrounds
    static let vibrant = BackgroundContent.gradient(.purple, .green)
    
    /// Neutral baseline
    static let neutral = BackgroundContent.solid(.gray)
    
    /// Busy checkerboard for testing clarity and separation
    static let busy = BackgroundContent.busy(.black, .white)
    
    /// Low contrast (light)
    static let lightContent = BackgroundContent.solid(.white)
    
    /// Low contrast (dark)
    static let darkContent = BackgroundContent.solid(.black)
}
