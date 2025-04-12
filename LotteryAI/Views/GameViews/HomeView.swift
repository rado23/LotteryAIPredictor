import SwiftUI

struct HomeView: View {
    @State private var selectedGame: GameType = .euroMillions
    @StateObject private var fetcher = PredictionFetcher()

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Select Game", selection: $selectedGame) {
                    ForEach(GameType.allCases, id: \.self) { game in
                        Text(game.displayName).tag(game)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if fetcher.isLoading {
                    ProgressView("Loading predictions...")
                        .padding()
                } else if let predictions = fetcher.predictions[selectedGame] {
                    List {
                        ForEach(predictions.indices, id: \.self) { index in
                            PredictionRow(prediction: predictions[index], gameType: selectedGame)
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Text("No predictions available.")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationTitle("Lottery Predictions")
            .onAppear {
                Task {
                    await fetcher.fetch(for: selectedGame)
                }
            }
            .onChange(of: selectedGame) { newGame in
                Task {
                    await fetcher.fetch(for: newGame)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
