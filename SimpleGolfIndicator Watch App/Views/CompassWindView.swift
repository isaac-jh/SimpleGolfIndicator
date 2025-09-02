import SwiftUI

// MARK: - 나침반/풍향풍속 뷰
struct CompassWindView: View {
    @ObservedObject var compassService: CompassService
    @ObservedObject var weatherService: WeatherService
    
    var body: some View {
        ZStack {
            // 배경 원형 이미지 (15도마다 눈금, 45도마다 긴 눈금)
            Circle()
                .fill(Color.white)
                .overlay(
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                )
                .overlay(
                    // 눈금 그리기
                    ForEach(0..<24, id: \.self) { index in
                        let angle = Double(index) * 15.0
                        let isLongTick = index % 3 == 0
                        
                        Rectangle()
                            .fill(Color.black)
                            .frame(
                                width: isLongTick ? 3 : 1,
                                height: isLongTick ? 20 : 10
                            )
                            .offset(y: -80)
                            .rotationEffect(.degrees(angle))
                    }
                )
            
            // 나침반 바늘 (CompassCursor)
            Image("CompassCursor")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(-compassService.heading))
            
            // 풍향 바늘 (WindCursor)
            if let weather = weatherService.currentWeather {
                Image("WindCursor")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(weather.windDeg - compassService.heading))
                    .overlay(
                        // 풍속 표시
                        Text(String(format: "%.1f", weather.windSpeed))
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.8))
                                    .frame(width: 40, height: 40)
                            )
                    )
            }
            
            // 중앙 점
            Circle()
                .fill(Color.black)
                .frame(width: 6, height: 6)
        }
        .frame(width: 200, height: 200)
        .onAppear {
            compassService.startCompass()
        }
        .onDisappear {
            compassService.stopCompass()
        }
    }
}

// MARK: - 미리보기
struct CompassWindView_Previews: PreviewProvider {
    static var previews: some View {
        CompassWindView(
            compassService: CompassService(),
            weatherService: WeatherService()
        )
    }
}
