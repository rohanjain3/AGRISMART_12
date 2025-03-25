import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Explore Tab
            ExploreView()
                .tabItem {
                    
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            // Home Tab
            NavigationView {
                ProductListView()
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
            .tag(1)
            
            
            // Farmers Tab
            FarmersListView1()
                .tabItem {
                    Label("Farmers", systemImage: "person.2")
                }
                .tag(2)
            
            // Chat Tab
            
            ChatListView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(3)
            
            // Settings Tab
            ConsumerSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(4)
        }
    }
}

// Update your ContentView to use the tab bar
struct ContentView: View {
    var body: some View {
        MainTabView()

    }
}

#Preview {
    ContentView()
}
