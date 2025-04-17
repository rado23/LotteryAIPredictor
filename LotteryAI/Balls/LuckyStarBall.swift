import SwiftUI

struct LuckyStarBall: View {
    let number: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.yellow.opacity(0.3))
                .frame(width: 32, height: 32)

            Text("\(number)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.black)
            
            VStack {
            
                HStack {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.yellow)
                        .offset(x: 10, y: -4)
                }
                Spacer()
            }
            .padding(4)
        }
        .accessibilityLabel("Lucky Star number \(number)")
    }
}
