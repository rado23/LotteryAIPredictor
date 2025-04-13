import SwiftUI

struct HomeView: View {
    @ObservedObject var savedManager = SavedPredictionsManager()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Ready to be a Millionaire?")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("Let AI and other digital friends help you predict the winning numbers.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text("Push the button to change your life")
                    .font(.headline)
                    .padding(.top)

                ForEach(GameType.allCases, id: \.self) { game in
                    NavigationLink(destination: PredictionView(game: game, savedManager: savedManager)) {
                        Text("🔮 Predict \(game.displayName) numbers!")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }

                Spacer()

                if let nextDrawDate = getNextDrawDate() {
                    Text("🗓️ Next draw: \(nextDrawDate)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.bottom, 12)
                }
            }
            .padding()
            .navigationTitle("Lottery AI")
        }
    }

    func getNextDrawDate() -> String? {
        // TODO: Optional logic if you want to show next draw date
        return nil
    }
}
