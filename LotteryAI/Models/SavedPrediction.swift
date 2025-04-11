import Foundation

struct SavedPrediction: Identifiable, Codable, Equatable {
    let id: UUID
    let game: GameType
    let date: Date
    let main: [Int]
    let stars: [Int]

    init(id: UUID = UUID(), game: GameType, date: Date, main: [Int], stars: [Int]) {
        self.id = id
        self.game = game
        self.date = date
        self.main = main
        self.stars = stars
    }
}
