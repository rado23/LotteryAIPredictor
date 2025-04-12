import SwiftUI

struct SavedView: View {
    @ObservedObject var savedManager: SavedPredictionsManager
    @State private var showCopyToast = false

    private func copyToClipboard(_ prediction: SavedPrediction) {
        let text = "Main: \(prediction.main.map(String.init).joined(separator: ", ")), Stars: \(prediction.stars.map(String.init).joined(separator: ", "))"
        UIPasteboard.general.string = text
        withAnimation {
            showCopyToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopyToast = false
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if savedManager.saved.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(sortedGames, id: \.self) { game in
                            Section(header: Text(game.displayName)) {
                                ForEach(groupedPredictions[game] ?? []) { prediction in
                                    SavedPredictionRow(
                                        prediction: prediction,
                                        onCopy: {
                                            copyToClipboard(prediction)
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .navigationTitle("Saved Predictions")
                }

                if showCopyToast {
                    VStack {
                        Spacer()
                        Text("Copied!")
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .transition(.opacity)
                            .zIndex(1)
                        Spacer().frame(height: 40)
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("No saved predictions yet!")
                .font(.title2)
                .foregroundColor(.gray)

            Text("Once you find a set you like, tap 💾 to save it here.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Saved Predictions")
    }

    private var sortedGames: [GameType] {
        Array(Set(savedManager.saved.map { $0.game }))
            .sorted { $0.rawValue < $1.rawValue }
    }

    private var groupedPredictions: [GameType: [SavedPrediction]] {
        Dictionary(grouping: savedManager.saved, by: { $0.game })
    }
}
