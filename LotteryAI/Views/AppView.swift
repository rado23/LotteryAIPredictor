import SwiftUI

struct AppView: View {
    @StateObject private var savedManager = SavedPredictionsManager()

    var body: some View {
        TabView {
            HomeView(savedManager: savedManager)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            SavedView(savedManager: savedManager)
                .tabItem {
                    Label("Saved", systemImage: "bookmark.fill")
                }
        }
    }
}
