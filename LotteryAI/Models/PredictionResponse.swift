import Foundation

struct PredictionResponse: Codable {
    let heuristic: [NumberSet]
    let ml: NumberSet?
}

struct NumberSet: Codable {
    let main: [Int]
    let stars: [Int]
    let source: SecondarySource?

    enum CodingKeys: String, CodingKey {
        case main = "main_numbers"
        case stars = "lucky_stars"
        case thunderball
        case lifeBall = "life_ball"
    }

    enum SecondarySource: String, Codable {
        case luckyStars
        case thunderball
        case setForLife
    }

    // Standard decoder
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)

        // Fallback for Lotto array-style: just main numbers
        if var unkeyed = try? decoder.unkeyedContainer() {
            var mainNumbers: [Int] = []
            while !unkeyed.isAtEnd {
                let number = try unkeyed.decode(Int.self)
                mainNumbers.append(number)
            }
            self.main = mainNumbers
            self.stars = []
            self.source = nil
            return
        }

        guard let container = container else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid NumberSet format.")
            )
        }

        self.main = try container.decode([Int].self, forKey: .main)

        if let stars = try? container.decode([Int].self, forKey: .stars) {
            self.stars = stars
            self.source = .luckyStars
        } else if let tb = try? container.decode(Int.self, forKey: .thunderball) {
            self.stars = [tb]
            self.source = .thunderball
        } else if let lb = try? container.decode(Int.self, forKey: .lifeBall) {
            self.stars = [lb]
            self.source = .setForLife
        } else {
            self.stars = []
            self.source = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(main, forKey: .main)

        switch source {
        case .luckyStars:
            try container.encode(stars, forKey: .stars)
        case .thunderball:
            if let tb = stars.first {
                try container.encode(tb, forKey: .thunderball)
            }
        case .setForLife:
            if let lb = stars.first {
                try container.encode(lb, forKey: .lifeBall)
            }
        case .none:
            break
        }
    }

    // Optional: manual init for fallback decoding
    init(main: [Int], stars: [Int] = [], source: SecondarySource? = nil) {
        self.main = main
        self.stars = stars
        self.source = source
    }
}
