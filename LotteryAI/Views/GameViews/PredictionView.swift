import SwiftUI

struct PredictionView: View {
    @State private var showAllHeuristics = false
    @Binding var predictions: [NumberSet]
    var mlPrediction: NumberSet?
    let game: GameType
    @ObservedObject var savedManager: SavedPredictionsManager

    var body: some View {
        NavigationView {
            List {
                // Heuristic Section
                if !predictions.isEmpty {
                    heuristicSection(predictions)
                }

                // ML Section
                if let ml = mlPrediction {
                    mlSection(ml)
                }
            }
            .navigationTitle(game.displayName + " Predictions")
        }
    }

    // MARK: - Heuristic Section
    private func heuristicSection(_ sets: [NumberSet]) -> some View {
        let visibleSets = Array(sets.prefix(showAllHeuristics ? sets.count : 1))

        return Section(header: Text("Heuristic Predictions")) {
            ForEach(visibleSets.indices, id: \.self) { index in
                let set = visibleSets[index]
                let isSaved = savedManager.saved.contains {
                    $0.main == set.main && $0.stars == set.stars && $0.game == game
                }

                PredictionRow(
                    set: set,
                    type: game,
                    isSaved: isSaved,
                    onSave: {
                        savedManager.savePrediction(game: game, main: set.main, stars: set.stars)
                    },
                    onCopy: {
                        let copyText = "Main: \(set.main.map(String.init).joined(separator: ", ")), Stars: \(set.stars.map(String.init).joined(separator: ", "))"
                        UIPasteboard.general.string = copyText
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
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: - ML Section
    private func mlSection(_ set: NumberSet) -> some View {
        let isSaved = savedManager.saved.contains {
            $0.main == set.main && $0.stars == set.stars && $0.game == game
        }

        return Section(header: Text("ML Prediction")) {
            PredictionRow(
                set: set,
                type: game,
                isSaved: isSaved,
                onSave: {
                    savedManager.savePrediction(game: game, main: set.main, stars: set.stars)
                },
                onCopy: {
                    let copyText = "Main: \(set.main.map(String.init).joined(separator: ", ")), Stars: \(set.stars.map(String.init).joined(separator: ", "))"
                    UIPasteboard.general.string = copyText
                }
            )
        }
    }
}
