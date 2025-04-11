import SwiftUI

struct LuckyStarBall: View {
    let number: Int

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Circle()
                .fill(Color.yellow.opacity(0.3))
                .frame(width: 32, height: 32)

            Text("\(number)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
                .frame(width: 32, height: 32)

            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .foregroundColor(.yellow)
                .offset(x: 6, y: -6)
        }
    }
}
