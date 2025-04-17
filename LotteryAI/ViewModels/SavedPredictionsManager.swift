import Foundation

class SavedPredictionsManager: ObservableObject {
    @Published var saved: [SavedPrediction] = []

    private let key = "saved_predictions"

    init() {
        load()
    }

    func savePrediction(game: GameType, main: [Int], stars: [Int]) {
        let new = SavedPrediction(game: game, date: Date(), main: main, stars: stars)
        if !saved.contains(new) {
            saved.append(new)
            persist()
        }
    }

    func removePrediction(_ prediction: SavedPrediction) {
        saved.removeAll { $0.id == prediction.id }
        persist()
    }

    private func persist() {
        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SavedPrediction].self, from: data) {
            saved = decoded
        }
    }
    
    func unsavePrediction(game: GameType, main: [Int], stars: [Int]) {
        saved.removeAll {
            $0.game == game && $0.main == main && $0.stars == stars
        }
        persist()
    }

}
