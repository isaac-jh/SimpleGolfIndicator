import SwiftUI

// MARK: - 메인 화면
struct MainView: View {
    @ObservedObject var courseDataService: CourseDataService
    @StateObject private var weatherService = WeatherService()
    @StateObject private var compassService = CompassService()
    @Binding var selectedCountryClub: CountryClub?
    @Binding var selectedCourse: Course?
    @Binding var selectedHole: Hole?
    @Binding var showingModal: Bool
    
    var body: some View {
        ZStack {
            // 잔디색 배경
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.6, blue: 0.2), // 진한 잔디색
                    Color(red: 0.4, green: 0.8, blue: 0.4)  // 밝은 잔디색
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 중앙 콘텐츠
            HStack(spacing: 0) {
                // 좌측 50% 영역
                VStack {
                    VStack(spacing: 12) {
                        // 코스명
                        Text(selectedCourse?.name ?? "SKY")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 홀 넘버
                        Text("Hole \(selectedHole?.num ?? 1)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 파
                        Text("Par \(selectedHole?.par ?? 4)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 홀 전장
                        Text("\(selectedHole?.distance ?? 375)m")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 80, height: 40)
                            .background(Color.black)
                            .clipShape(Circle())
                        
                        // 고도차
                        HStack(spacing: 4) {
                            if let elevation = selectedHole?.elevation {
                                if elevation > 0 {
                                    // 오르막
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.red)
                                        .font(.system(size: 16, weight: .bold))
                                    Text("\(String(format: "%.1f", elevation))m")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.red)
                                } else {
                                    // 내리막
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 16, weight: .bold))
                                    Text("\(String(format: "%.1f", abs(elevation)))m")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Text("0.0m")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 80, height: 40)
                        .background(Color.black)
                        .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // 나침반/풍향풍속 뷰
                    CompassWindView(
                        compassService: compassService,
                        weatherService: weatherService
                    )
                }
                .frame(maxWidth: .infinity)
                
                // 우측 50% 영역
                Rectangle()
                    .fill(Color.clear)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.y < -50 && !showingModal {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingModal = true
                        }
                    }
                }
        )
        .onChange(of: selectedCountryClub) { newCountryClub in
            if let countryClub = newCountryClub {
                // 선택된 CC의 위치로 날씨 데이터 가져오기 시작
                weatherService.startAutoRefresh(
                    latitude: countryClub.location.latitude,
                    longitude: countryClub.location.longitude
                )
            } else {
                weatherService.stopAutoRefresh()
            }
        }
    }
}
