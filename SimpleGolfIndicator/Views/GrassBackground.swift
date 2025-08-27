import SwiftUI

struct GrassBackground: View {
    @State private var grassOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // 기본 잔디색 배경
            Color.green.opacity(0.3)
                .ignoresSafeArea()
            
            // 잔디 패턴 레이어 1 (큰 잔디)
            ForEach(0..<20) { index in
                GrassBlade(
                    width: CGFloat.random(in: 8...15),
                    height: CGFloat.random(in: 40...80),
                    color: Color.green.opacity(Double.random(in: 0.4...0.7)),
                    delay: Double(index) * 0.1
                )
                .offset(
                    x: CGFloat.random(in: -200...200),
                    y: CGFloat.random(in: -400...400)
                )
                .rotationEffect(.degrees(Double.random(in: -30...30)))
            }
            
            // 잔디 패턴 레이어 2 (중간 잔디)
            ForEach(0..<30) { index in
                GrassBlade(
                    width: CGFloat.random(in: 5...10),
                    height: CGFloat.random(in: 25...50),
                    color: Color.green.opacity(Double.random(in: 0.3...0.6)),
                    delay: Double(index) * 0.15
                )
                .offset(
                    x: CGFloat.random(in: -250...250),
                    y: CGFloat.random(in: -500...500)
                )
                .rotationEffect(.degrees(Double.random(in: -45...45)))
            }
            
            // 잔디 패턴 레이어 3 (작은 잔디)
            ForEach(0..<40) { index in
                GrassBlade(
                    width: CGFloat.random(in: 3...7),
                    height: CGFloat.random(in: 15...35),
                    color: Color.green.opacity(Double.random(in: 0.2...0.5)),
                    delay: Double(index) * 0.2
                )
                .offset(
                    x: CGFloat.random(in: -300...300),
                    y: CGFloat.random(in: -600...600)
                )
                .rotationEffect(.degrees(Double.random(in: -60...60)))
            }
            
            // 바람에 흔들리는 잔디 효과
            ForEach(0..<15) { index in
                WavingGrass(
                    delay: Double(index) * 0.3,
                    offset: grassOffset
                )
            }
        }
        .onAppear {
            withAnimation(
                Animation.linear(duration: 8)
                    .repeatForever(autoreverses: false)
            ) {
                grassOffset = 20
            }
        }
    }
}

// MARK: - 개별 잔디 잎
struct GrassBlade: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color
    let delay: Double
    
    @State private var isAnimating = false
    
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: height/2))
            path.addQuadCurve(
                to: CGPoint(x: 0, y: -height/2),
                control: CGPoint(x: width/2, y: 0)
            )
            path.addQuadCurve(
                to: CGPoint(x: 0, y: height/2),
                control: CGPoint(x: -width/2, y: 0)
            )
        }
        .fill(
            LinearGradient(
                colors: [color, color.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .frame(width: width, height: height)
        .scaleEffect(isAnimating ? 1.1 : 1.0)
        .opacity(isAnimating ? 0.8 : 1.0)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 2 + delay)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

// MARK: - 바람에 흔들리는 잔디
struct WavingGrass: View {
    let delay: Double
    let offset: CGFloat
    
    @State private var isWaving = false
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.green.opacity(0.6),
                                Color.green.opacity(0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 3, height: 30)
                    .cornerRadius(2)
                    .offset(x: isWaving ? offset * 0.5 : 0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(delay + Double(index) * 0.1),
                        value: isWaving
                    )
            }
        }
        .onAppear {
            isWaving = true
        }
    }
}

// MARK: - 잔디 질감 오버레이
struct GrassTexture: View {
    var body: some View {
        Canvas { context, size in
            // 잔디 질감을 위한 작은 점들
            for _ in 0..<1000 {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let opacity = Double.random(in: 0.1...0.3)
                let size = CGFloat.random(in: 1...3)
                
                let path = Path { p in
                    p.addEllipse(in: CGRect(x: x, y: y, width: size, height: size))
                }
                
                context.fill(
                    path,
                    with: .color(Color.green.opacity(opacity))
                )
            }
        }
        .opacity(0.4)
    }
}

#Preview {
    ZStack {
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
