import Foundation

enum GameType: String, Codable, CaseIterable, Identifiable {
    case euroMillions = "EuroMillions"
    case thunderball = "Thunderball"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .euroMillions: return "EuroMillions"
        case .thunderball: return "Thunderball"
        }
    }
}
