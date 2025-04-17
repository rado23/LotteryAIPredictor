import Foundation

struct SavedPrediction: Identifiable, Codable, Equatable {
    let id: UUID
    let game: GameType
    let date: Date
    let main: [Int]
    let stars: [Int]  // Could be lucky stars, thunderball, or life ball
    let source: SecondarySource?  // Optional, for identifying type of stars

    init(
        id: UUID = UUID(),
        game: GameType,
        date: Date,
        main: [Int],
        stars: [Int] = [],
        source: SecondarySource? = nil
    ) {
        self.id = id
        self.game = game
        self.date = date
        self.main = main
        self.stars = stars
        self.source = source
    }
}

enum SecondarySource: String, Codable {
    case luckyStars
    case thunderball
    case setForLife
}
