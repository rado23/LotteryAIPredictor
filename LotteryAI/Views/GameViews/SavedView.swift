import SwiftUI

struct SavedView: View {
<<<<<<< HEAD
    @ObservedObject var manager: SavedPredictionsManager

    var body: some View {
        NavigationView {
            if manager.saved.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "sparkles")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.blue.opacity(0.6))

                    Text("No saved predictions yet!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("Once you find a set you like, tap 💾 to save it here.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Image(systemName: "arrow.down.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.blue.opacity(0.4))
                        .offset(y: 10)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .navigationTitle("Saved Predictions")
            } else {
                List {
                    ForEach(["Heuristic", "ML"], id: \.self) { type in
                        let filtered = manager.saved
                            .filter { $0.type == type }
                            .sorted(by: { $0.date > $1.date }) // Newest first

                        if !filtered.isEmpty {
                            Section(header: Text("\(type) Predictions")) {
                                ForEach(filtered) { prediction in
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(prediction.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)

                                        HStack {
                                            ForEach(prediction.main, id: \.self) { num in
                                                Text("\(num)")
                                                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                                                    .frame(width: 32, height: 32)
                                                    .background(Circle().fill(Color.blue.opacity(0.2)))
                                            }

                                            ForEach(prediction.stars, id: \.self) { star in
                                                HStack(spacing: 4) {
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(.yellow)
                                                    Text("\(star)")
                                                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                                                }
                                                .padding(6)
                                                .background(Capsule().fill(Color.yellow.opacity(0.2)))
                                            }
                                        }
                                    }
                                    .padding(.vertical, 6)
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            manager.remove(prediction)
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Saved Predictions")
            }
        }
    }
=======
    @ObservedObject var savedManager: SavedPredictionsManager
    @State private var showCopyToast = false

    private func copyToClipboard(_ prediction: SavedPrediction) {
        let text = "Main: \(prediction.main.map(String.init).joined(separator: ", ")), Stars: \(prediction.stars.map(String.init).joined(separator: ", "))"
        UIPasteboard.general.string = text
        withAnimation {
            showCopyToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showCopyToast = false
            }
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                if savedManager.saved.isEmpty {
                    emptyState
                } else {
                    List {
                        ForEach(sortedGames, id: \.self) { game in
                            predictionSection(for: game)
                        }
                    }
                    .navigationTitle("Saved Predictions")
                }

                if showCopyToast {
                    VStack {
                        Spacer()
                        Text("Copied!")
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .transition(.opacity)
                            .zIndex(1)
                        Spacer().frame(height: 40)
                    }
                    .transition(.opacity)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("No saved predictions yet!")
                .font(.title2)
                .foregroundColor(.gray)

            Text("Once you find a set you like, tap 💾 to save it here.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .navigationTitle("Saved Predictions")
    }

    @ViewBuilder
    private func predictionSection(for game: GameType) -> some View {
        let predictions = groupedPredictions[game] ?? []
        let manager = savedManager // ✅ helps Swift with resolving context

        Section(header: Text("\(game.rawValue) Predictions")) {
            ForEach(predictions) { prediction in
                SavedPredictionRow(
                    prediction: prediction,
                    onCopy: {
                        let copyText = "Main: \(prediction.main.map(String.init).joined(separator: ", ")), Stars: \(prediction.stars.map(String.init).joined(separator: ", "))"
                        UIPasteboard.general.string = copyText
                    }
                )
            }
        }
    }



    private var sortedGames: [GameType] {
        Array(Set(savedManager.saved.map { $0.game })).sorted(by: { $0.rawValue > $1.rawValue })
    }

    private var groupedPredictions: [GameType: [SavedPrediction]] {
        Dictionary(grouping: savedManager.saved, by: { $0.game })
    }

}

struct SavedPredictionRow: View {
    let prediction: SavedPrediction
    let onCopy: () -> Void
    @State private var isCopied = false

    var body: some View {
        Button(action: {
            onCopy()
            withAnimation(.easeIn(duration: 0.2)) {
                isCopied = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isCopied = false
                }
            }
        }) {
            HStack(spacing: 6) {
                ForEach(prediction.main, id: \.self) { num in
                    Text("\(num)")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                }

                ForEach(prediction.stars, id: \.self) { star in
                    LuckyStarBall(number: star)
                }

                Spacer()
            }
            .padding(.vertical, 4)
            .background(isCopied ? Color.green.opacity(0.15) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
>>>>>>> temp-branch
}
