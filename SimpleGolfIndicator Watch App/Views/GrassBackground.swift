import SwiftUI

struct GrassBackground: View {
    var body: some View {
        // 단순한 잔디색 배경
        LinearGradient(
            colors: [
                Color(red: 0.2, green: 0.5, blue: 0.2), // 진한 잔디색
                Color(red: 0.4, green: 1, blue: 0.4),  // 밝은 잔디색
                Color(red: 0.2, green: 0.5, blue: 0.2) // 진한 잔디색
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack(alignment: .center) {
        GrassBackground()
        
        VStack {
            Text("골프 인디케이터")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .shadow(radius: 5)
            
            Text("잔디 배경 테스트")
                .font(.headline)
                .foregroundColor(.white)
                .shadow(radius: 3)
        }
    }
}
