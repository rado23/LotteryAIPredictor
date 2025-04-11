import SwiftUI

struct AppView: View {
    @State private var predictions: PredictionResponse? = nil
    @State private var isLoading = false
    @StateObject private var savedManager = SavedPredictionsManager()

    var body: some View {
        TabView {
            HomeView(
                predictions: $predictions,
                isLoading: $isLoading,
                savedManager: savedManager
            )
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
