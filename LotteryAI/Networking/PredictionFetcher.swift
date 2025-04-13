import Foundation

struct PredictionContainer: Decodable {
    let heuristic: [NumberSet]?
    let ml: NumberSet?
}

@MainActor
class PredictionFetcher: ObservableObject {
    @Published var predictions: [GameType: [NumberSet]] = [:]
    @Published var mlPredictions: [GameType: NumberSet] = [:]
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetch(for game: GameType) async {
        isLoading = true
        errorMessage = nil

        guard let url = URL(string: "https://lottery-ai-pro.onrender.com/predict/\(game.endpoint)") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        do {
            print("🌍 Fetching from URL: \(url)")
            let (data, _) = try await URLSession.shared.data(from: url)
            print("📦 Received data: \(data.count) bytes")

            let decoded = try JSONDecoder().decode(PredictionContainer.self, from: data)

            if let heuristic = decoded.heuristic {
                self.predictions[game] = heuristic
            }

            if let ml = decoded.ml {
                self.mlPredictions[game] = ml
            }

            if decoded.heuristic == nil && decoded.ml == nil {
                self.errorMessage = "No predictions found"
            }
        } catch {
            self.errorMessage = "❌ Error fetching predictions: \(error.localizedDescription)"
            print("❌ Error fetching predictions: \(error.localizedDescription)")
        }

        isLoading = false
    }
}
