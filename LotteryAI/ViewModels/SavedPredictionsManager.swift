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
        saved.removeAll { $0 == prediction }
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        let key = "savedPredictions" // define your key here if not defined elsewhere
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SavedPrediction].self, from: data) {
            saved = decoded
        }
    }

    
    private func save() {
        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: "savedPredictions")
        }
    }

    
    func remove(_ prediction: SavedPrediction) {
        saved.removeAll { $0.id == prediction.id }
        save()
    }

}
