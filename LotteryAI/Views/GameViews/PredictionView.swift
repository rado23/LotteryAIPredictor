import SwiftUI

struct PredictionView: View {

    @State private var showAllHeuristics = false
    @Binding var predictions: PredictionResponse?
    @ObservedObject var savedManager: SavedPredictionsManager

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading predictions...")
                } else if let predictions = predictions {
                    List {
                        // MARK: Heuristic Predictions
                        Section(header: Text("Heuristic Predictions")) {
                            let visibleCount = showAllHeuristics ? predictions.heuristic.count : 1
                            ForEach(predictions.heuristic.prefix(visibleCount).indices, id: \.self) { index in
                                let set = predictions.heuristic[index]
                                let isSaved = savedManager.saved.contains {
                                    $0.main == set.main && $0.stars == set.stars && $0.type == "Heuristic"
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        // Main numbers
                                        ForEach(set.main, id: \.self) { num in
                                            Text("\(num)")
                                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                                .frame(width: 32, height: 32)
                                                .background(Circle().fill(Color.blue.opacity(0.2)))
                                        }

                                        // Lucky stars as star icons
                                        ForEach(set.stars, id: \.self) { star in
                                            HStack(spacing: 4) {
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                                Text("\(star)")
                                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            }
                                            .padding(6)
                                            .background(Capsule().fill(Color.yellow.opacity(0.2)))

                                        }
                                    }

                                    Button(action: {
                                        withAnimation(.easeIn(duration: 0.2)) {
                                            savedManager.savePrediction(type: "Heuristic", main: set.main, stars: set.stars)
                                        }
                                    }) {
                                        Text(isSaved ? "Saved" : "💾 Save")
                                            .padding(6)
                                            .frame(maxWidth: .infinity)
                                            .background(isSaved ? Color.gray.opacity(0.2) : Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                    .disabled(isSaved)
                                    .font(.caption)
                                }
                                .padding(.vertical, 4)
                            }

                            if predictions.heuristic.count > 1 {
                                Button(showAllHeuristics ? "Show Less" : "Show More") {
                                    withAnimation {
                                        showAllHeuristics.toggle()
                                    }
                                }
                                .foregroundColor(.blue)
                                .padding(.vertical, 4)
                            }
                        }

                        // MARK: ML Prediction
                        Section(header: Text("ML Prediction")) {
                            let set = predictions.ml
                            let isSaved = savedManager.saved.contains {
                                $0.main == set.main && $0.stars == set.stars && $0.type == "ML"
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    ForEach(set.main, id: \.self) { num in
                                        Text("\(num)")
                                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                                            .frame(width: 32, height: 32)
                                            .background(Circle().fill(Color.blue.opacity(0.2)))
                                    }

                                    ForEach(set.stars, id: \.self) { star in
                                        HStack(spacing: 4) {
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                            Text("\(star)")
                                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                        }
                                        .padding(6)
                                        .background(Capsule().fill(Color.yellow.opacity(0.2)))

                                    }
                                }

                                Button(action: {
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        savedManager.savePrediction(type: "ML", main: set.main, stars: set.stars)
                                    }
                                }) {
                                    Text(isSaved ? "Saved" : "💾 Save")
                                        .padding(6)
                                        .frame(maxWidth: .infinity)
                                        .background(isSaved ? Color.gray.opacity(0.2) : Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                }
                                .disabled(isSaved)
                                .font(.caption)
                            }
                        }
                    }
                } else {
                    Text("Failed to load predictions.")

                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Lottery AI Predictor")
        }

    }

    // MARK: - Heuristic Section
    private func heuristicSection(_ sets: [NumberSet]) -> some View {
        let visibleSets = Array(sets.prefix(showAllHeuristics ? sets.count : 1))

        return Section(header: Text("Heuristic Predictions")) {
            ForEach(visibleSets.indices, id: \.self) { index in
                let set = visibleSets[index]
                let isSaved = savedManager.saved.contains {
                    $0.main == set.main && $0.stars == set.stars && $0.type == "Heuristic" && $0.game == GameType.euroMillions
                }

                PredictionRow(
                    set: set,
                    game: GameType.euroMillions,
                    type: "Heuristic",
                    isSaved: isSaved,
                    onSave: {
                        savedManager.save(
                            game: GameType.euroMillions,
                            type: "Heuristic",
                            main: set.main,
                            stars: set.stars
                        )
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
            $0.main == set.main && $0.stars == set.stars && $0.type == "ML" && $0.game == GameType.euroMillions
        }

        return Section(header: Text("ML Prediction")) {
            PredictionRow(
                set: set,
                game: GameType.euroMillions,
                type: "ML",
                isSaved: isSaved,
                onSave: {
                    savedManager.save(
                        game: GameType.euroMillions,
                        type: "ML",
                        main: set.main,
                        stars: set.stars
                    )
                },
                onCopy: {
                    let copyText = "Main: \(set.main.map(String.init).joined(separator: ", ")), Stars: \(set.stars.map(String.init).joined(separator: ", "))"
                    UIPasteboard.general.string = copyText
                }
            )
        }

    }
}
