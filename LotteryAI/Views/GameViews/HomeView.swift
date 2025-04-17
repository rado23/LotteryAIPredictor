import SwiftUI

struct HomeView: View {
    @StateObject private var fetcher = PredictionFetcher()
    @ObservedObject var savedManager = SavedPredictionsManager()
    @State private var fetchTimestamps: [GameType: Date] = [:]

    var body: some View {
        NavigationStack {
            List {
                ForEach(GameType.allCases, id: \.self) { game in
                    GameSectionView(
                        game: game,
                        isLoading: fetcher.isLoading,
                        fetchTimestamp: fetchTimestamps[game],
                        savedManager: savedManager,
                        fetcher: fetcher
                    )
                }
            }
            .navigationTitle("Lottery AI Assistant")
        }
    }
}


extension GameType {
    var nextDrawFormatted: String {
        let nextDate = nextDrawDate(for: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        return formatter.string(from: nextDate)
    }

    private func nextDrawDate(for game: GameType) -> Date {
        let calendar = Calendar.current
        let today = Date()

        let targetWeekdays: [Int] = {
            switch game {
            case .euroMillions: return [3, 6]         // Tuesday, Friday
            case .thunderball: return [3, 4, 6, 7]     // Tue, Wed, Fri, Sat
            case .lotto: return [4, 7]                // Wed, Sat
            case .setForLife: return [2, 5]           // Mon, Thu
            }
        }()

        let nextDates = targetWeekdays.compactMap {
            calendar.nextDate(after: today, matching: DateComponents(weekday: $0), matchingPolicy: .nextTime)
        }

        return nextDates.min() ?? today
    }
}
