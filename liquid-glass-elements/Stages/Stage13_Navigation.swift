import SwiftUI

/// Stage 13 — Navigation, toolbars, and floating control architecture
///
/// Objective: Compare a system-toolbar approach with a custom floating palette,
/// then decide where each control belongs.
struct Stage13_Navigation: View {
    private enum ArchitectureMode: String, CaseIterable {
        case systemToolbar = "System Toolbar"
        case customPalette = "Floating Palette"
    }

    private struct Stage13Article: Identifiable {
        let id = UUID()
        let title: String
        let subtitle: String
        let category: String
    }

    @State private var selectedBackground: BackgroundSelection = .vibrant
    @State private var mode: ArchitectureMode = .systemToolbar
    @State private var query = ""
    @State private var selectedCategory = "All"
    @State private var showingCompose = false
    @State private var showingFilters = false

    private let categories = ["All", "Design", "Code", "Research"]

    private var allArticles: [Stage13Article] {
        [
            Stage13Article(title: "Liquid hierarchy in feed screens", subtitle: "Use elevation only for controls.", category: "Design"),
            Stage13Article(title: "Floating actions and safe areas", subtitle: "Palette placement in portrait and landscape.", category: "Code"),
            Stage13Article(title: "Search behavior under translucent UI", subtitle: "Keep content first, controls second.", category: "Research"),
            Stage13Article(title: "Toolbar actions vs custom controls", subtitle: "Prefer system first, customize with intent.", category: "Design"),
            Stage13Article(title: "When to group controls", subtitle: "Only merge controls that share task semantics.", category: "Code"),
            Stage13Article(title: "Accessibility adaptation checklist", subtitle: "Contrast, touch targets, reduced motion.", category: "Research")
        ]
    }

    private var filteredArticles: [Stage13Article] {
        allArticles.filter { article in
            let categoryMatch = selectedCategory == "All" || article.category == selectedCategory
            let queryMatch = query.isEmpty
                || article.title.localizedCaseInsensitiveContains(query)
                || article.subtitle.localizedCaseInsensitiveContains(query)
            return categoryMatch && queryMatch
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                selectedBackground.backgroundContent.view()
                    .ignoresSafeArea()

                contentList
            }
            .navigationTitle("Stage 13")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $query, prompt: "Search articles")
            .sheet(isPresented: $showingCompose) {
                Stage13ComposeSheet()
            }
            .sheet(isPresented: $showingFilters) {
                Stage13FiltersSheet(selectedCategory: $selectedCategory, categories: categories)
            }
            .toolbar {
                if mode == .systemToolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showingFilters = true
                        } label: {
                            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }

                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            selectedCategory = "All"
                            query = ""
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }

                        Button {
                            showingCompose = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomArchitecturePanel
            }
            .safeAreaInset(edge: .bottom) {
                if mode == .customPalette {
                    floatingPaletteInset
                }
            }
        }
    }

    private var contentList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                Stage13CategoryChips(categories: categories, selected: $selectedCategory)
                    .padding(.top, 4)

                ForEach(filteredArticles) { article in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(article.category.uppercased())
                            .font(.caption2.weight(.semibold))
                            .foregroundColor(.secondary)

                        Text(article.title)
                            .font(.headline)

                        Text(article.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }

                if filteredArticles.isEmpty {
                    Text("No results for current filters")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    private var bottomArchitecturePanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Architecture")
                .font(.caption.weight(.bold))

            Picker("Architecture", selection: $mode) {
                ForEach(ArchitectureMode.allCases, id: \.self) { option in
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

            Text(mode == .systemToolbar
                 ? "System mode: navigation, toolbar, search, and safe-area behavior are handled by SwiftUI."
                 : "Custom mode: floating controls are useful only when toolbar placement cannot express the interaction model.")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(.thinMaterial)
    }

    @ViewBuilder
    private var floatingPaletteInset: some View {
        HStack {
            Spacer()

            if #available(iOS 26, *) {
                Stage13FloatingPaletteGlass(
                    onFilter: { showingFilters = true },
                    onReset: {
                        selectedCategory = "All"
                        query = ""
                    },
                    onCompose: { showingCompose = true }
                )
            } else {
                Stage13FloatingPaletteFallback(
                    onFilter: { showingFilters = true },
                    onReset: {
                        selectedCategory = "All"
                        query = ""
                    },
                    onCompose: { showingCompose = true }
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

private struct Stage13CategoryChips: View {
    let categories: [String]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(category) {
                        selected = category
                    }
                    .buttonStyle(.bordered)
                    .tint(selected == category ? .accentColor : .secondary)
                }
            }
        }
    }
}

private struct Stage13ComposeSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Draft") {
                    TextField("Title", text: .constant(""))
                    TextField("Summary", text: .constant(""))
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

private struct Stage13FiltersSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: String
    let categories: [String]

    var body: some View {
        NavigationStack {
            List(categories, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    HStack {
                        Text(category)
                        Spacer()
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

@available(iOS 26, *)
private struct Stage13FloatingPaletteGlass: View {
    let onFilter: () -> Void
    let onReset: () -> Void
    let onCompose: () -> Void

    @Namespace private var namespace

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            HStack(spacing: 0) {
                Stage13GlassButton(title: "Filter", systemImage: "line.3.horizontal.decrease.circle", id: "filter", namespace: namespace, action: onFilter)
                Stage13GlassButton(title: "Reset", systemImage: "arrow.clockwise", id: "reset", namespace: namespace, action: onReset)
                Stage13GlassButton(title: "Compose", systemImage: "square.and.pencil", id: "compose", namespace: namespace, action: onCompose)
            }
        }
    }
}

@available(iOS 26, *)
private struct Stage13GlassButton: View {
    let title: String
    let systemImage: String
    let id: String
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
        .glassEffect(.regular.interactive(), in: Capsule())
        .glassEffectID(id, in: namespace)
    }
}

private struct Stage13FloatingPaletteFallback: View {
    let onFilter: () -> Void
    let onReset: () -> Void
    let onCompose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onFilter) {
                Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
            }
            .buttonStyle(.borderedProminent)

            Button(action: onReset) {
                Label("Reset", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.bordered)

            Button(action: onCompose) {
                Label("Compose", systemImage: "square.and.pencil")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview("Stage 13 — Portrait") {
    Stage13_Navigation()
}

#Preview("Stage 13 — Landscape", traits: .fixedLayout(width: 932, height: 430)) {
    Stage13_Navigation()
}

#Preview("Stage 13 — Dark") {
    Stage13_Navigation()
        .preferredColorScheme(.dark)
}
