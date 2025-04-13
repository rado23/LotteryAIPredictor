import Foundation

struct PredictionContainer: Decodable {
    var heuristic: [PredictionResponse]?
    var ml: PredictionResponse?
}

@MainActor
class PredictionFetcher: ObservableObject {
    @Published var predictions: [GameType: [PredictionResponse]] = [:]
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
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(PredictionContainer.self, from: data)

            var combined: [PredictionResponse] = []

            if let heuristic = decoded.heuristic {
                combined.append(contentsOf: heuristic)
            }

            if let ml = decoded.ml {
                combined.append(ml)
            }

            if combined.isEmpty {
                self.errorMessage = "No predictions found"
            }

            self.predictions[game] = combined
        } catch {
            self.errorMessage = "Failed to load: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
