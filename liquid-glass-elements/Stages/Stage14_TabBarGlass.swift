import SwiftUI

fileprivate enum Stage14_TabMode: String, CaseIterable {
    case system = "System TabView"
    case custom = "Custom Floating Bar"
}

fileprivate enum Stage14_TabSection: String, CaseIterable, Hashable {
    case home = "Home"
    case discover = "Discover"
    case profile = "Profile"

    var symbol: String {
        switch self {
        case .home: return "house"
        case .discover: return "sparkles"
        case .profile: return "person.crop.circle"
        }
    }

    var blurb: String {
        switch self {
        case .home:
            return "A tab bar is usually system chrome. The OS decides the material, spacing, and selection behavior."
        case .discover:
            return "This tab bar automatically adapts to the background, appearance, and accessibility settings."
        case .profile:
            return "You generally customize the content under the tab bar, not the bar’s glass treatment itself."
        }
    }
}

/// Stage 14 - Tab bar glass and system chrome
///
/// Objective: Show that tab bars get their glass-like treatment from system
/// context, and compare that with a custom floating bar that you style yourself.
struct Stage14_TabBarGlass: View {
    @State private var mode: Stage14_TabMode = .system
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var selection: Stage14_TabSection = .home

    var body: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            if mode == .system {
                systemTabView
            } else {
                customFloatingBarView
            }

            VStack {
                topControls
                Spacer()
            }
        }
    }

    private var systemTabView: some View {
        TabView(selection: $selection) {
            ForEach(Stage14_TabSection.allCases, id: \.self) { section in
                Stage14_TabPage(section: section, background: selectedBackground)
                    .tabItem {
                        Label(section.rawValue, systemImage: section.symbol)
                    }
                    .tag(section)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .tint(.blue)
    }

    private var customFloatingBarView: some View {
        ZStack {
            selectedBackground.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Stage14_SelectedSectionCard(section: selection, background: selectedBackground)

                    Stage14_InfoCard(
                        title: "Manual bar",
                        text: "This version imitates a tab bar with a custom floating capsule. It gives you complete control, but you own every spacing and background decision."
                    )

                    Stage14_InfoCard(
                        title: "What to notice",
                        text: "The bar is no longer system chrome. It is just another view, so you have to decide exactly how much glass, blur, and contrast it needs."
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 72)
                .padding(.bottom, 120)
            }
            .safeAreaInset(edge: .bottom) {
                Stage14_CustomTabBar(selection: $selection)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        }
    }

    private var topControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stage 14 - Tab bar glass")
                .font(.headline)

            Picker("Mode", selection: $mode) {
                ForEach(Stage14_TabMode.allCases, id: \.self) { option in
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

            Text(mode == .system
                 ? "System tab bars are glass by context: the OS owns the chrome."
                 : "Custom bars can look similar, but you must build the glass treatment yourself.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

private struct Stage14_TabPage: View {
    let section: Stage14_TabSection
    let background: BackgroundSelection

    var body: some View {
        ZStack {
            background.backgroundContent.view()
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Stage14_SelectedSectionCard(section: section, background: background)

                    Stage14_InfoCard(
                        title: "Automatic chrome",
                        text: "The tab bar at the bottom is managed by the system. On supported platforms, it adapts its material and contrast without you styling each tab item by hand."
                    )

                    Stage14_InfoCard(
                        title: "Design question",
                        text: "Ask whether you want a navigation choice, a context choice, or a floating action cluster. If it is a tab choice, the system tab bar is usually the right answer."
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 72)
                .padding(.bottom, 24)
            }
        }
    }
}

private struct Stage14_SelectedSectionCard: View {
    let section: Stage14_TabSection
    let background: BackgroundSelection

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: section.symbol)
                    .font(.title3)
                    .foregroundColor(.accentColor)
                Text(section.rawValue)
                    .font(.title2.bold())
            }

            Text(section.blurb)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct Stage14_InfoCard: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct Stage14_CustomTabBar: View {
    @Binding var selection: Stage14_TabSection

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Stage14_TabSection.allCases, id: \.self) { section in
                Button {
                    selection = section
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: section.symbol)
                            .font(.system(size: 18, weight: .semibold))
                        Text(section.rawValue)
                            .font(.caption2)
                    }
                    .foregroundColor(selection == section ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(selection == section ? Color.primary.opacity(0.10) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
    }
}

#Preview("Stage 14 - System TabView") {
    Stage14_TabBarGlass()
}

#Preview("Stage 14 - Custom Floating Bar") {
    Stage14_TabBarGlass()
}

#Preview("Stage 14 - Dark") {
    Stage14_TabBarGlass()
        .preferredColorScheme(.dark)
}
