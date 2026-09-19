import SwiftUI

fileprivate enum Stage18_Filter: String, CaseIterable {
    case all = "All"
    case favorites = "Favorites"
    case recent = "Recent"
}

fileprivate struct Stage18_Entry: Identifiable {
    let id: Int
    let title: String
    let summary: String
}

/// Stage 18 - Final Liquid Glass interface
///
/// Objective: combine content, system navigation, a small custom floating
/// glass group, one interactive control, and one semantic morphing transition.
struct Stage18_FinalInterface: View {
    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var searchText = ""
    @State private var filter: Stage18_Filter = .all
    @State private var favoriteIDs: Set<Int> = []
    @State private var showingComposer = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let entries: [Stage18_Entry] = (1...20).map {
        Stage18_Entry(
            id: $0,
            title: "Story \($0)",
            summary: "A content-first card with one meaningful control. Glass stays on interaction surfaces, not the whole article body."
        )
    }

    private var visibleEntries: [Stage18_Entry] {
        entries.filter { entry in
            let matchesSearch = searchText.isEmpty
                || entry.title.localizedCaseInsensitiveContains(searchText)
                || entry.summary.localizedCaseInsensitiveContains(searchText)

            let matchesFilter: Bool
            switch filter {
            case .all:
                matchesFilter = true
            case .favorites:
                matchesFilter = favoriteIDs.contains(entry.id)
            case .recent:
                matchesFilter = entry.id <= 8
            }

            return matchesSearch && matchesFilter
        }
    }

    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    selectedBackground.backgroundContent.view()
                        .ignoresSafeArea()

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(visibleEntries) { entry in
                                Stage18_ContentCard(
                                    entry: entry,
                                    isFavorite: favoriteIDs.contains(entry.id),
                                    onToggleFavorite: { toggleFavorite(entry.id) }
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 10)
                        .padding(.bottom, 120)
                    }
                }
//                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Liquid Journal")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, prompt: "Search stories")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker("Filter", selection: $filter) {
                                ForEach(Stage18_Filter.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 12) {
                            Menu {
                                Picker("Background", selection: $selectedBackground) {
                                    ForEach(BackgroundSelection.allCases, id: \.self) { bg in
                                        Text(bg.label).tag(bg)
                                    }
                                }
                            } label: {
                                Label("Options", systemImage: "slider.horizontal.3")
                            }

                            Button {
                                showingComposer = true
                            } label: {
                                Image(systemName: "square.and.pencil")
                            }
                            .accessibilityLabel("Compose")
                        }
                    }
                }
//                .safeAreaInset(edge: .top) {
//                    // Stage18_ControlsOverlay()
//                }
            }
        }
        .sheet(isPresented: $showingComposer) {
            NavigationStack {
                Form {
                    Text("Composer placeholder")
                        .foregroundStyle(.secondary)
                }
                .navigationTitle("New Entry")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Done") { showingComposer = false }
                    }
                }
            }
        }
    }

    private func toggleFavorite(_ id: Int) {
        if reduceMotion {
            if favoriteIDs.contains(id) {
                favoriteIDs.remove(id)
            } else {
                favoriteIDs.insert(id)
            }
            return
        }

        withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
            if favoriteIDs.contains(id) {
                favoriteIDs.remove(id)
            } else {
                favoriteIDs.insert(id)
            }
        }
    }
}

private struct Stage18_ControlsOverlay: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Stage 18 - Final Interface")
                .font(.headline)
            Text("Content-first scroll + system nav + focused controls")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }
}

private struct Stage18_ContentCard: View {
    let entry: Stage18_Entry
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.title)
                        .font(.headline)
                    Text(entry.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(isFavorite ? Color.pink : .primary)
                        .frame(minWidth: 44, minHeight: 44)
                        .background(favoriteSurface)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isFavorite ? "Remove favorite" : "Add favorite")
            }

            Text("Readable content surface remains plain; only controls are elevated.")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @ViewBuilder
    private var favoriteSurface: some View {
        if #available(iOS 26, *) {
            Color.clear
                .glassEffect(.regular.interactive(), in: Capsule())
        } else {
            Capsule().fill(.thinMaterial)
        }
    }
}

#Preview("Stage 18 - Final") {
    Stage18_FinalInterface()
}

#Preview("Stage 18 - Dark") {
    Stage18_FinalInterface()
        .preferredColorScheme(.dark)
}
