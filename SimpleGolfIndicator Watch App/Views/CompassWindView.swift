import SwiftUI

// MARK: - 나침반/풍향풍속 뷰
struct CompassWindView: View {
    @ObservedObject var compassService: CompassService
    @ObservedObject var weatherService: WeatherService
    
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let tickOffset = -size * 0.4
            let longTickWidth = max(size * 0.02, 2)
            let shortTickWidth = max(size * 0.008, 1)
            let longTickHeight = max(size * 0.14, 10)
            let shortTickHeight = max(size * 0.07, 6)
            
            ZStack {
                // 배경 원형 이미지 (15도마다 눈금, 45도마다 긴 눈금)
                Circle()
                    .fill(Color.white)
                    .overlay(
                        Circle()
                            .stroke(Color.black, lineWidth: max(size * 0.014, 2))
                    )
                    .overlay(
                        // 눈금 그리기
                        ForEach(0..<24, id: \.self) { index in
                            let angle = Double(index) * 15.0
                            let isLongTick = index % 3 == 0
                            
                            Rectangle()
                                .fill(Color.black)
                                .frame(
                                    width: isLongTick ? longTickWidth : shortTickWidth,
                                    height: isLongTick ? longTickHeight : shortTickHeight
                                )
                                .offset(y: tickOffset)
                                .rotationEffect(.degrees(angle))
                        }
                    )
                
                // 나침반 바늘 (CompassCursor)
                Image("CompassCursor")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size * 0.75, height: size * 0.75)
                    .rotationEffect(.degrees(-compassService.heading), anchor: .center)
                
                // 풍향 바늘 (WindCursor)
                if let weather = weatherService.currentWeather {
                    Image("WindCursor")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: size * 0.62, height: size * 0.62)
                        .rotationEffect(.degrees(weather.windDeg - compassService.heading), anchor: .center)
                        .overlay(
                            // 풍속 표시
                            Text(String(format: "%.1f", weather.windSpeed))
                                .font(.system(size: max(size * 0.1, 12), weight: .bold))
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .fill(Color.white.opacity(0.85))
                                        .frame(width: size * 0.26, height: size * 0.26)
                                )
                        )
                } else if weatherService.isLoading {
                    // 로딩 중일 때 표시
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: size * 0.62, height: size * 0.62)
                        .overlay(
                            ProgressView()
                                .scaleEffect(0.5)
                                .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        )
                } else if weatherService.errorMessage != nil {
                    // 에러 발생 시 표시
                    Circle()
                        .stroke(Color.red.opacity(0.3), lineWidth: 2)
                        .frame(width: size * 0.62, height: size * 0.62)
                        .overlay(
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.red)
                                .font(.system(size: max(size * 0.1, 12)))
                        )
                }
                
                // 중앙 점
                Circle()
                    .fill(Color.black)
                    .frame(width: max(size * 0.035, 4), height: max(size * 0.035, 4))
            }
            .frame(width: size, height: size)
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear { compassService.startCompass() }
        .onDisappear { compassService.stopCompass() }
    }
}

// MARK: - 미리보기
struct CompassWindView_Previews: PreviewProvider {
    static var previews: some View {
        CompassWindView(
            compassService: CompassService(),
            weatherService: WeatherService()
        )
        .frame(width: 80, height: 80)
    }
}
