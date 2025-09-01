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
                path.addLine(to: CGPoint(x: -size/8, y: size/8))
                path.addLine(to: CGPoint(x: 0, y: size/4))
                path.addLine(to: CGPoint(x: size/8, y: size/8))
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
                path.addLine(to: CGPoint(x: -size/8, y: -size/8))
                path.addLine(to: CGPoint(x: 0, y: -size/4))
                path.addLine(to: CGPoint(x: size/8, y: -size/8))
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
                .frame(width: size/8, height: size/8)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .white.opacity(0.8), radius: 1)
        }
        .frame(width: size, height: size)
        .rotationEffect(.degrees(-heading))
    }
}

// MARK: - 향상된 눈금 (15도 간격)
struct EnhancedTickMarks: View {
    let color: Color
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 15도마다 눈금 (24개)
            ForEach(0..<24, id: \.self) { index in
                let angle = Double(index) * 15.0
                let isMajor = index % 3 == 0 // 45도마다 주요 눈금
                
                Rectangle()
                    .fill(color)
                    .frame(
                        width: 1,
                        height: isMajor ? 8 : 4
                    )
                    .offset(y: -size * 0.4)
                    .rotationEffect(.degrees(angle))
            }
        }
    }
}

// MARK: - 애니메이션된 원형 배경 (흰색 배경)
struct AnimatedCircleBackground: View {
    let color: Color
    let size: CGFloat
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            // 흰색 배경 원
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            // 외부 테두리
            Circle()
                .stroke(color.opacity(0.3), lineWidth: 2)
                .frame(width: size, height: size)
            
            // 내부 테두리
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 1)
                .frame(width: size * 0.8, height: size * 0.8)
            
            // 애니메이션된 점선 원
            Circle()
                .stroke(
                    color.opacity(0.4),
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

// MARK: - 통합 나침반/풍향 뷰
struct IntegratedCompassWindView: View {
    let heading: Double
    let windDirection: Double
    let windSpeed: Double
    let size: CGFloat
    
    var body: some View {
        ZStack {
            // 흰색 원형 배경
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            // 외부 테두리
            Circle()
                .stroke(Color.orange.opacity(0.3), lineWidth: 2)
                .frame(width: size, height: size)
            
            // 내부 테두리
            Circle()
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                .frame(width: size * 0.8, height: size * 0.8)
            
            // 향상된 눈금 (검정색)
            EnhancedTickMarks(color: .black, size: size)
            
            // 나침반 바늘
            CompassNeedle(heading: heading, size: size * 0.4)
            
            // 풍향 화살표 (나침반 바늘 위에, 약간 오프셋)
            WindArrow(direction: windDirection, size: size * 0.3)
                .offset(x: size * 0.15, y: -size * 0.15)
            
            // 풍속 숫자 (우측 하단에 배치)
            VStack(spacing: 1) {
                Text("\(String(format: "%.1f", windSpeed))")
                    .font(.system(size: size * 0.1, weight: .bold))
                    .foregroundColor(.blue)
                    .shadow(color: .black.opacity(0.3), radius: 1, x: 0.5, y: 0.5)
                
                Text("m/s")
                    .font(.system(size: size * 0.05, weight: .medium))
                    .foregroundColor(.blue.opacity(0.8))
                    .shadow(color: .black.opacity(0.2), radius: 0.5, x: 0.25, y: 0.25)
            }
            .offset(x: size * 0.2, y: size * 0.2)
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
