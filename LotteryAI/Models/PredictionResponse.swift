import Foundation

struct PredictionResponse: Codable {
    let heuristic: [NumberSet]
    let ml: NumberSet
}

struct NumberSet: Codable {
    let main: [Int]
    let stars: [Int]

    enum CodingKeys: String, CodingKey {
        case main = "main_numbers"
        case stars = "lucky_stars"
    }
}
