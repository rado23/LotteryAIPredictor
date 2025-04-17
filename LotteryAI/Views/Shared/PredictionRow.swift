import SwiftUI

struct PredictionRow: View {
    let set: NumberSet
    let type: GameType
    let isSaved: Bool
    let onSave: () -> Void
    let onCopy: () -> Void
    let onUnsave: () -> Void


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
                ForEach(set.main, id: \.self) { num in
                    Text("\(num)")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(Color.blue.opacity(0.2)))
                }

                ForEach(set.stars, id: \.self) { star in
                    switch set.source {
                    case .thunderball:
                        ThunderBall(number: star)
                    case .setForLife:
                        SetForLifeBall(number: star)
                    default:
                        LuckyStarBall(number: star)
                    }
                }


                Spacer()

                Text(isSaved ? "✅" : "💾")
                    .font(.system(size: 20))
                    .onTapGesture {
                        if isSaved {
                            onUnsave()
                        } else {
                            onSave()
                        }
                    }

            }
            .padding(.vertical, 4)
            .background(isCopied ? Color.green.opacity(0.15) : Color.clear)
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
