import SwiftUI

struct ThunderBall: View {
    let number: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.pink.opacity(0.3))
                .frame(width: 32, height: 32)

            Text("\(number)")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(.black)

            VStack {
                HStack {
                    Text("TB")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(2)
                        .background(Circle().fill(Color.pink))
                        .offset(x: 12, y: -4)
                }
                Spacer()
            }
            .padding(4)
        }
        .accessibilityLabel("Thunderball number \(number)")
    }
}
