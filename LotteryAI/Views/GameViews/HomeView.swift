import SwiftUI

struct HomeView: View {
    @State private var selectedGame: GameType = .euroMillions
    @StateObject private var fetcher = PredictionFetcher()
    @ObservedObject var savedManager = SavedPredictionsManager()

    var body: some View {
        NavigationStack {
            VStack {
                gamePicker
                predictionsView(for: selectedGame)
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

    private var gamePicker: some View {
        Picker("Select Game", selection: $selectedGame) {
            ForEach(GameType.allCases, id: \.self) { game in
                Text(game.displayName).tag(game)
            }
        }
        .pickerStyle(.segmented)
        .padding()
    }

    @ViewBuilder
    private func predictionsView(for game: GameType) -> some View {
        if fetcher.isLoading {
            ProgressView("Loading predictions...")
                .padding()
        } else if let responses = fetcher.predictions[game], let response = responses.last {
            predictionsList(for: response, game: game)
        } else {
            Text("No predictions available.")
                .foregroundColor(.gray)
                .padding()
        }
    }

    @ViewBuilder
    private func predictionsList(for response: PredictionResponse, game: GameType) -> some View {
        List {
            if !response.heuristic.isEmpty {
                Section(header: Text("Heuristic Predictions")) {
                    ForEach(response.heuristic.indices, id: \.self) { index in
                        let set = response.heuristic[index]
                        predictionRow(for: set, game: game)
                    }
                }
            }

            Section(header: Text("ML Prediction")) {
                predictionRow(for: response.ml, game: game)
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private func predictionRow(for prediction: NumberSet, game: GameType) -> some View {
        PredictionRow(
            set: prediction,
            type: game,
            isSaved: savedManager.saved.contains {
                $0.main == prediction.main && $0.stars == prediction.stars && $0.game == game
            },
            onSave: {
                savedManager.savePrediction(game: game, main: prediction.main, stars: prediction.stars)
            },
            onCopy: {
                let text = "Main: \(prediction.main.map(String.init).joined(separator: ", ")), Stars: \(prediction.stars.map(String.init).joined(separator: ", "))"
                UIPasteboard.general.string = text
            }
        )
    }
}
