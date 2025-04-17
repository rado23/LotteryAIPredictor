import Foundation

struct MLPredictionWrapper: Decodable {
    let ml: NumberSet
}

@MainActor
class PredictionFetcher: ObservableObject {
    @Published var predictions: [GameType: [NumberSet]] = [:]
    @Published var mlPredictions: [GameType: NumberSet] = [:]
    @Published var secondaryLabel: [GameType: String] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch(for game: GameType) async {
        isLoading = true
        errorMessage = nil

        do {
            // === Heuristic fetch ===
            let mainURL = URL(string: "https://lottery-ai-pro.onrender.com/predict/\(game.endpoint)")!
            print("🌍 Fetching heuristic from \(mainURL)")
            let (mainData, _) = try await URLSession.shared.data(from: mainURL)
            print("📦 Heuristic data: \(mainData.count) bytes")

            var fetchedHeuristic: [NumberSet] = []

            // Try decoding as { heuristic: [...] }
            if let decoded = try? JSONDecoder().decode([String: [NumberSet]].self, from: mainData),
               let heuristic = decoded["heuristic"] {
                fetchedHeuristic = heuristic
            } else if let fallback = try? JSONDecoder().decode([NumberSet].self, from: mainData) {
                fetchedHeuristic = fallback
            } else if game == .lotto,  // Handle Lotto's special array-of-arrays format
                      let lottoRaw = try? JSONDecoder().decode([String: [[Int]]].self, from: mainData),
                      let lottoHeuristic = lottoRaw["heuristic"] {
                fetchedHeuristic = lottoHeuristic.map { NumberSet(main: $0, stars: [], source: nil) }
            } else {
                print("❌ Failed to decode heuristic for \(game)")
            }

            predictions[game] = fetchedHeuristic

            // Infer secondary number label based on range or game type
            if let first = fetchedHeuristic.first, let secondary = first.stars.first {
                switch game {
                case .setForLife:
                    secondaryLabel[game] = "Life Ball"
                case .thunderball:
                    secondaryLabel[game] = "Thunderball"
                case .euroMillions:
                    secondaryLabel[game] = "Lucky Stars"
                default:
                    secondaryLabel[game] = "Stars"
                }
            }

            // === ML fetch (if applicable) ===
            let mlEndpoint = "\(game.endpoint)-ml"
            let mlURL = URL(string: "https://lottery-ai-pro.onrender.com/predict/\(mlEndpoint)")!
            print("🌍 Fetching ML from \(mlURL)")
            let (mlData, _) = try await URLSession.shared.data(from: mlURL)
            print("📦 ML data: \(mlData.count) bytes")

            if let decoded = try? JSONDecoder().decode(MLPredictionWrapper.self, from: mlData) {
                mlPredictions[game] = decoded.ml
            } else if let altDecoded = try? JSONDecoder().decode([String: NumberSet].self, from: mlData),
                      let ml = altDecoded["ml"] {
                mlPredictions[game] = ml
            } else {
                print("❌ Failed to decode ML for \(game)")
            }

        } catch {
            self.errorMessage = "❌ Error fetching predictions: \(error.localizedDescription)"
            print(self.errorMessage!)
        }

        isLoading = false
    }
}
