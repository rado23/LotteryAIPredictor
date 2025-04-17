import SwiftUI

struct PredictionView: View {
    @ObservedObject var fetcher: PredictionFetcher
    let game: GameType
    @ObservedObject var savedManager: SavedPredictionsManager
    @State private var showAllHeuristics = false
    @State private var hasFetched = false
    @State private var refreshTimestamp: Date?

    var body: some View {
        VStack {
            if fetcher.isLoading {
                VStack(spacing: 12) {
                    ProgressView("Generating your numbers...")
                    Text("Please stay calm while we consult the AI and statistical spirits 🧙‍♂️")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                    Text("Becoming a millionaire takes a moment. Hang tight!")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding()
            } else if let heuristic = fetcher.predictions[game], let ml = fetcher.mlPredictions[game] {
                predictionList(heuristic: heuristic, ml: ml)
            } else if let heuristic = fetcher.predictions[game] {
                predictionList(heuristic: heuristic, ml: nil)
            } else if let ml = fetcher.mlPredictions[game] {
                predictionList(heuristic: [], ml: ml)
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save All") {
                    if let heuristic = fetcher.predictions[game] {
                        for set in heuristic {
                            savedManager.savePrediction(game: game, main: set.main, stars: set.stars)
                        }
                    }
                    if let ml = fetcher.mlPredictions[game] {
                        savedManager.savePrediction(game: game, main: ml.main, stars: ml.stars)
                    }
                }
            }
        }
        .navigationTitle(game.displayName)
        .navigationBarItems(trailing: refreshButton)
        .onAppear {
            if !hasFetched, fetcher.predictions[game] == nil && fetcher.mlPredictions[game] == nil {
                Task {
                    await fetcher.fetch(for: game)
                    refreshTimestamp = Date()
                    hasFetched = true
                }
            }
        }
    }

    @ViewBuilder
    private func predictionList(heuristic: [NumberSet], ml: NumberSet?) -> some View {
        List {
            if !heuristic.isEmpty {
                heuristicSection(heuristic)
            }

            if let ml = ml {
                mlSection(ml)
            }

            if let ts = refreshTimestamp {
                Text("Last refreshed: \(relativeDateString(from: ts)) ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .listStyle(.insetGrouped)
    }

    @ViewBuilder
    private func heuristicSection(_ sets: [NumberSet]) -> some View {
        let visible = showAllHeuristics ? sets : Array(sets.prefix(1))

        Section(header: Text("Heuristic Predictions")) {
            ForEach(Array(visible.enumerated()), id: \.offset) { _, set in
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
                    },
                    onUnsave: {
                        savedManager.unsavePrediction(game: game, main: set.main, stars: set.stars)
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
                },
                onUnsave: {
                    savedManager.unsavePrediction(game: game, main: set.main, stars: set.stars)
                }
            )
        }
    }

    private var refreshButton: some View {
        Button(action: {
            Task {
                await fetcher.fetch(for: game)
                refreshTimestamp = Date()
            }
        }) {
            Text("Refresh")
        }
    }

    private func relativeDateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
