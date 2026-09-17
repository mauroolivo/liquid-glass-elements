import SwiftUI

/// Stage 2 — System Liquid Glass before Custom Liquid Glass
///
/// Objective: Understand that most UI hierarchy problems are solved by appropriate
/// system components (NavigationStack, Toolbar, TabView, etc.) BEFORE resorting to
/// custom Liquid Glass.
///
/// Mental model: System components already provide adaptive styling. Use them first.
/// Custom glass is justified only when system components don't fit the interaction model.

struct Stage2_SystemGlass: View {
    @State private var showSystemVersion: Bool = true
    @State private var selectedBackground: BackgroundSelection = .vibrant
    
    var body: some View {
        ZStack {
            // Background
            selectedBackground.backgroundContent.view()
            
            // Main content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 8) {
                    Text("Stage 2: System Components")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("System glass vs. Custom floating palette")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(.thinMaterial)
                
                // Main content
                if showSystemVersion {
                    SystemBasedApproach()
                } else {
                    CustomFloatingApproach()
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
                        Text("Implementation:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Picker("Version", selection: $showSystemVersion) {
                            Text("📱 System Toolbar").tag(true)
                            Text("✨ Custom Floating").tag(false)
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    Text("Toggle to compare: When should you use system components vs. custom glass?")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .background(.thinMaterial)
            }
        }
    }
}

// MARK: - System-Based Approach (Recommended)

struct SystemBasedApproach: View {
    @State private var selectedTab: Int = 0
    @State private var showAddSheet = false
    @State private var searchText = ""
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1: Articles
            NavigationStack {
                List {
                    ForEach(0..<5, id: \.self) { index in
                        NavigationLink(destination: Text("Article \(index + 1) Details")) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Article \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Summary of article content...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .navigationTitle("Articles")
                .searchable(text: $searchText, prompt: "Search articles")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddSheet = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                        }
                    }
                }
                .sheet(isPresented: $showAddSheet) {
                    VStack(spacing: 16) {
                        Text("Add New Article")
                            .font(.headline)
                        
                        TextField("Title", text: .constant(""))
                            .textFieldStyle(.roundedBorder)
                            .padding()
                        
                        Button("Create") {
                            showAddSheet = false
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                        
                        Spacer()
                    }
                }
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("Articles")
            }
            .tag(0)
            
            // Tab 2: Favorites
            NavigationStack {
                List {
                    ForEach(0..<3, id: \.self) { index in
                        NavigationLink(destination: Text("Favorite \(index + 1)")) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Favorite \(index + 1)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Starred content")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .navigationTitle("Favorites")
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            .tag(1)
            
            // Tab 3: Settings
            NavigationStack {
                Form {
                    Section(header: Text("Appearance")) {
                        Picker("Theme", selection: .constant(0)) {
                            Text("Light").tag(0)
                            Text("Dark").tag(1)
                            Text("Auto").tag(2)
                        }
                    }
                    
                    Section(header: Text("Notifications")) {
                        Toggle("Enable notifications", isOn: .constant(true))
                    }
                }
                .navigationTitle("Settings")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }
            .tag(2)
        }
    }
}

// MARK: - Custom Floating Approach (Not Recommended)

struct CustomFloatingApproach: View {
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            // Content
            List {
                ForEach(0..<8, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Item \(index + 1)")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Content summary...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .searchable(text: $searchText, prompt: "Search")
            
            // Custom floating palette
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("📱 System Toolbar")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                        
                        VStack(spacing: 8) {
                            BulletPointText("✅ Automatic system styling")
                            BulletPointText("✅ Adapts to safe areas")
                            BulletPointText("✅ Consistent with iOS conventions")
                            BulletPointText("✅ Handles rotation/notches")
                            BulletPointText("✅ Accessibility built-in")
                        }
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(8)
                        
                        Text("✨ Custom Floating")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(12)
                        
                        VStack(spacing: 8) {
                            BulletPointText("❌ You manage styling")
                            BulletPointText("❌ You handle safe areas")
                            BulletPointText("❌ You match iOS patterns")
                            BulletPointText("❌ You handle rotation/notches")
                            BulletPointText("❌ You implement accessibility")
                        }
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.red.opacity(0.05))
                        .cornerRadius(8)
                        
                        Text("When Custom Glass Is Justified")
                            .font(.caption)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BulletPointText("• Unique interaction model (e.g., expandable compact actions)")
                            BulletPointText("• Immersive experience requires floating controls")
                            BulletPointText("• Context-sensitive actions tied to content beneath")
                            BulletPointText("• System components don't fit the design")
                        }
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.blue.opacity(0.05))
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: 280)
                    .padding(12)
                    .background(Material.thick)
                    .cornerRadius(12)
                    .padding(12)
                }
            }
        }
    }
}

// MARK: - Previews

#Preview("Stage 2 — Vibrant Background") {
    Stage2_SystemGlass()
}

#Preview("Stage 2 — Dark Mode") {
    Stage2_SystemGlass()
        .preferredColorScheme(.dark)
}

#Preview("Stage 2 — Large Type") {
    Stage2_SystemGlass()
        .environment(\.sizeCategory, .accessibilityExtraExtraLarge)
}

#Preview("Stage 2 — Reduce Transparency") {
    Stage2_SystemGlass()
        .preferredColorScheme(.light)
}
