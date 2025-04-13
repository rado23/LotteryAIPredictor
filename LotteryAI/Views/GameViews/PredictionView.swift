import SwiftUI

struct PredictionView: View {
    @ObservedObject var fetcher: PredictionFetcher
    let game: GameType
    @ObservedObject var savedManager: SavedPredictionsManager
    @State private var showAllHeuristics = false
    @State private var hasFetched = false


    var body: some View {
        VStack {
            if fetcher.isLoading {
                ProgressView("Fetching predictions for \(game.displayName)...")
                    .padding()
            } else if let heuristic = fetcher.predictions[game], let ml = fetcher.mlPredictions[game] {
                List {
                    heuristicSection(heuristic)
                    mlSection(ml)
                }
                .listStyle(.insetGrouped)
            } else if let heuristic = fetcher.predictions[game] {
                List {
                    heuristicSection(heuristic)
                }
                .listStyle(.insetGrouped)
            } else if let ml = fetcher.mlPredictions[game] {
                List {
                    mlSection(ml)
                }
                .listStyle(.insetGrouped)
            } else if let error = fetcher.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("No predictions found for \(game.displayName).")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .navigationTitle(game.displayName)
        .onAppear {
            if !hasFetched {
                Task {
                    await fetcher.fetch(for: game)
                    hasFetched = true
                }
            }
        }


    }

    @ViewBuilder
    private func heuristicSection(_ sets: [NumberSet]) -> some View {
        let visible = showAllHeuristics ? sets : Array(sets.prefix(1))

        Section(header: Text("Heuristic Predictions")) {
            ForEach(visible.indices, id: \.self) { index in
                let set = visible[index]
                PredictionRow(
                    set: set,
                    type: game,
                    isSaved: savedManager.saved.contains {
                        $0.main == set.main && $0.stars == set.stars && $0.game == game
                    },
                    onSave: {
                        savedManager.savePrediction(game: game, main: set.main, stars: set.stars)
                    },
                    onCopy: {
                        let text = "Main: \(set.main.map(String.init).joined(separator: ", ")), Stars: \(set.stars.map(String.init).joined(separator: ", "))"
                        UIPasteboard.general.string = text
                    }
                )
            }

            if sets.count > 1 {
                Button(showAllHeuristics ? "Show Less" : "Show More") {
                    withAnimation {
                        showAllHeuristics.toggle()
                    }
                }
                .foregroundColor(.blue)
                .font(.caption)
                .padding(.vertical, 4)
            }
        }
    }

    @ViewBuilder
    private func mlSection(_ set: NumberSet) -> some View {
        Section(header: Text("ML Prediction")) {
            PredictionRow(
                set: set,
                type: game,
                isSaved: savedManager.saved.contains {
                    $0.main == set.main && $0.stars == set.stars && $0.game == game
                },
                onSave: {
                    savedManager.savePrediction(game: game, main: set.main, stars: set.stars)
                },
                onCopy: {
                    let text = "Main: \(set.main.map(String.init).joined(separator: ", ")), Stars: \(set.stars.map(String.init).joined(separator: ", "))"
                    UIPasteboard.general.string = text
                }
            )
        }
    }
}
