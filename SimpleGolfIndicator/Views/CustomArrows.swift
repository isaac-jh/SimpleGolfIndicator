import SwiftUI

// MARK: - 커스텀 풍향 화살표
struct WindArrow: View {
    let direction: Double
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 화살표 몸체
            Path { path in
                path.move(to: CGPoint(x: 0, y: -size/2))
                path.addLine(to: CGPoint(x: -size/4, y: size/4))
                path.addLine(to: CGPoint(x: -size/8, y: size/4))
                path.addLine(to: CGPoint(x: -size/8, y: size/2))
                path.addLine(to: CGPoint(x: size/8, y: size/2))
                path.addLine(to: CGPoint(x: size/8, y: size/4))
                path.addLine(to: CGPoint(x: size/4, y: size/4))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [Color.blue, Color.blue.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // 화살표 중앙 선
            Rectangle()
                .fill(Color.white)
                .frame(width: 2, height: size/3)
                .shadow(color: .white.opacity(0.8), radius: 1)
        }
        .rotationEffect(.degrees(direction))
    }
}

// MARK: - 커스텀 나침반 바늘
struct CompassNeedle: View {
    let heading: Double
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 북쪽 바늘 (빨간색)
            Path { path in
                path.move(to: CGPoint(x: 0, y: -size/2))
                path.addLine(to: CGPoint(x: -size/6, y: size/6))
                path.addLine(to: CGPoint(x: 0, y: size/3))
                path.addLine(to: CGPoint(x: size/6, y: size/6))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [Color.red, Color.red.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .red.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // 남쪽 바늘 (검은색)
            Path { path in
                path.move(to: CGPoint(x: 0, y: size/2))
                path.addLine(to: CGPoint(x: -size/6, y: -size/6))
                path.addLine(to: CGPoint(x: 0, y: -size/3))
                path.addLine(to: CGPoint(x: size/6, y: -size/6))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [Color.black, Color.black.opacity(0.8)],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
            
            // 중앙 원
            Circle()
                .fill(Color.white)
                .frame(width: size/6, height: size/6)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.8), radius: 1)
        }
        .rotationEffect(.degrees(-heading))
    }
}

// MARK: - 향상된 눈금 표시
struct EnhancedTickMarks: View {
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 8방향 메인 눈금
            ForEach(0..<8) { index in
                let angle = Double(index) * 45.0
                
                VStack(spacing: 0) {
                    // 긴 눈금
                    Rectangle()
                        .fill(color)
                        .frame(width: 2, height: 12)
                        .shadow(color: color.opacity(0.3), radius: 1)
                    
                    // 짧은 눈금
                    Rectangle()
                        .fill(color.opacity(0.6))
                        .frame(width: 1, height: 6)
                        .offset(y: 2)
                }
                .offset(y: -size/2 + 8)
                .rotationEffect(.degrees(angle))
            }
            
            // 4방향 보조 눈금
            ForEach(0..<4) { index in
                let angle = Double(index) * 90.0
                
                Rectangle()
                    .fill(color.opacity(0.4))
                    .frame(width: 3, height: 16)
                    .offset(y: -size/2 + 6)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

// MARK: - 애니메이션된 원형 배경
struct AnimatedCircleBackground: View {
    let color: Color
    let size: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 외부 원
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 3)
                .frame(width: size, height: size)
            
            // 내부 원
            Circle()
                .stroke(color.opacity(0.1), lineWidth: 1)
                .frame(width: size * 0.8, height: size * 0.8)
            
            // 애니메이션된 점선 원
            Circle()
                .stroke(
                    color.opacity(0.3),
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: [4, 4]
                    )
                )
                .frame(width: size * 0.9, height: size * 0.9)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 20)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        HStack(spacing: 30) {
            WindArrow(direction: 45, size: 60)
            CompassNeedle(heading: 90, size: 60)
        }
        
        HStack(spacing: 30) {
            ZStack {
                AnimatedCircleBackground(color: .blue, size: 100)
                EnhancedTickMarks(color: .blue, size: 100)
            }
            
            ZStack {
                AnimatedCircleBackground(color: .orange, size: 100)
                EnhancedTickMarks(color: .orange, size: 100)
            }
        }
    }
    .padding()
}
