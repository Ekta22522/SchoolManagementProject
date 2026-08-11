import SwiftUI

struct LoadingView: View {

    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
          

            // Loading card
            VStack(spacing: 20) {

                Spinner(tint: .primary, lineWidth: 4)
                    .frame(width: 40, height: 40)

                Text(message)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 25)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 10)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LoadingView(message: "Logging in...")
}
