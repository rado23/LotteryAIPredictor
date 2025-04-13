import Foundation

enum GameType: String, Codable, CaseIterable, Identifiable {
    case euroMillions = "EuroMillions"
    case thunderball = "Thunderball"
    case lotto = "Lotto"
    case setForLife = "SetForLife"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .euroMillions: return "EuroMillions"
        case .thunderball: return "Thunderball"
        case .lotto: return "Lotto"
        case .setForLife: return "Set For Life"
        }
    }

    var endpoint: String {
        switch self {
        case .euroMillions: return "euromillions"
        case .thunderball: return "thunderball"
        case .lotto: return "lotto"
        case .setForLife: return "setforlife"
        }
    }
}
