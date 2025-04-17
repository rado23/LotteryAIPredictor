import SwiftUI

struct GameSectionView: View {
    let game: GameType
    let isLoading: Bool
    let fetchTimestamp: Date?
    let savedManager: SavedPredictionsManager
    let fetcher: PredictionFetcher

    var body: some View {
        Section(header: Text(game.displayName)) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Next draw: \(game.nextDrawFormatted)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                NavigationLink(destination: PredictionView(
                    fetcher: fetcher,
                    game: game,
                    savedManager: savedManager
                )) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(hasPredictions ? "📋 My predicted numbers" : "🔮 Predict the numbers")
                                .font(.headline)

                            if let timestamp = fetchTimestamp {
                                Text("Generated: \(relativeDateString(from: timestamp)) ago")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }

                        Spacer()

                        if isLoading {
                            ProgressView()
                        }
                    }
                }
                .disabled(isLoading)
            }
            .padding(.vertical, 8)
        }
    }

    private var hasPredictions: Bool {
        !(fetcher.predictions[game]?.isEmpty ?? true) || fetcher.mlPredictions[game] != nil
    }

    private func relativeDateString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
