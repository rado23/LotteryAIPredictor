import SwiftUI

struct HomeView: View {
    @Binding var predictions: PredictionResponse?
    @Binding var isLoading: Bool
    @ObservedObject var savedManager: SavedPredictionsManager
<<<<<<< HEAD
    @State private var navigateToPrediction = false

    var body: some View {
        NavigationStack {
=======
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
>>>>>>> temp-branch
            VStack(spacing: 30) {
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView("Generating your numbers...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()

                        Text("Please stay calm while we consult the AI and statistical spirits... 🧙‍♂️")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Text("Becoming a millionaire takes a moment. Hang tight!")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding()
                } else {
                    VStack(spacing: 16) {
                        Text("Ready to be a Millionaire?")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)

                        Text("Let AI and other digital friends help you predict the winning numbers.")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

<<<<<<< HEAD
                        Text("Push the button to change your life 🎯")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Button(action: {
                            fetchPredictions()
                        }) {
                            Text("🎰 Predict the Euro Million numbers!")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }

                    if let nextDrawDate = getNextDrawDate() {
                        Text("📅 Next draw: \(nextDrawDate.formatted(date: .long, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                }

                NavigationLink(
                    destination: {
                        if let predictions {
                            PredictionView(
                                predictions: Binding(get: { predictions }, set: { self.predictions = $0 }),
                                isLoading: $isLoading,
                                savedManager: savedManager
                            )
                        } else {
                            Text("No predictions available.")
                        }
                    },
                    isActive: $navigateToPrediction,
                    label: { EmptyView() }
                )
            }
            .padding()
            .navigationTitle("Lottery AI Predictor")
=======
                        if predictions == nil {
                            Text("Push the button to change your life 🎯")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Button(action: fetchPredictions) {
                                Text("🎰 Predict the EUROMILLIONS numbers!")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal)
                        } else {
                            HStack(spacing: 12) {
                                Button(action: {
                                    path.append("prediction")
                                }) {
                                    Text("Your EUROMILLIONS predictions")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(12)
                                }

                                Button(action: fetchPredictions) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.title2)
                                        .padding(10)
                                }
                                .buttonStyle(.borderless)
                                .help("Regenerate EUROMILLIONS prediction")
                            }
                            .padding(.horizontal)
                        }

                        if let nextDrawDate = getNextDrawDate() {
                            Text("📅 Next draw: \(nextDrawDate.formatted(date: .long, time: .omitted))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.top)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Lottery AI Predictor")
            .navigationDestination(for: String.self) { value in
                if value == "prediction" {
                    PredictionView(
                        predictions: $predictions,
                        savedManager: savedManager
                    )
                }
            }
>>>>>>> temp-branch
        }
    }

    func fetchPredictions() {
        isLoading = true

        guard let url = URL(string: "https://lottery-ai-pro.onrender.com/predict") else {
            print("Invalid URL")
            isLoading = false
            return
        }

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 180
        config.timeoutIntervalForResource = 180
        let session = URLSession(configuration: config)

        session.dataTask(with: url) { data, response, error in
            print("✅ Got a response or error")
            DispatchQueue.main.async {
                isLoading = false
            }

            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data")
                return
            }

            do {
                let decoded = try JSONDecoder().decode(PredictionResponse.self, from: data)
                DispatchQueue.main.async {
<<<<<<< HEAD
                    self.predictions = decoded
                    self.navigateToPrediction = true
=======
                    predictions = decoded
                    path.append("prediction")
>>>>>>> temp-branch
                }
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func getNextDrawDate() -> Date? {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)

        let daysUntilNextDraw: Int
        if weekday <= 2 {
            daysUntilNextDraw = 3 - weekday // next Tuesday
        } else if weekday <= 5 {
            daysUntilNextDraw = 6 - weekday // next Friday
        } else {
            daysUntilNextDraw = (10 - weekday) % 7 // next Tuesday
        }

        return calendar.date(byAdding: .day, value: daysUntilNextDraw, to: now)
    }
}
