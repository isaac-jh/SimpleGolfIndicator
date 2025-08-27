import SwiftUI
import CoreLocation

struct MainHoleView: View {
    let selectedCourse: Course
    let selectedHole: Hole
    let selectedGolfCourse: GolfCourse
    
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 잔디 배경
                GrassBackground()
                
                VStack(spacing: 0) {
                    // 상단 정보 바
                    HStack {
                        // 왼쪽 위 - 고도차
                        elevationView
                        
                        Spacer()
                        
                        // 오른쪽 위 - 거리
                        distanceView
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // 중앙 홀 이미지
                    holeImageView
                        .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5)
                    
                    Spacer()
                    
                    // 하단 정보 바
                    HStack {
                        // 왼쪽 아래 - 풍향 풍속
                        windInfoView
                        
                        Spacer()
                        
                        // 오른쪽 아래 - 나침반
                        compassView
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle("\(selectedHole.num)번 홀")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadWeatherData()
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
    }
    
    // MARK: - 고도차 뷰
    private var elevationView: some View {
        VStack(spacing: 8) {
            Text("고도차")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 4) {
                Image(systemName: selectedHole.elevation >= 0 ? "arrow.up" : "arrow.down")
                    .foregroundColor(selectedHole.elevation >= 0 ? .green : .red)
                    .font(.caption)
                
                Text("\(abs(selectedHole.elevation))m")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 거리 뷰
    private var distanceView: some View {
        VStack(spacing: 8) {
            Text("거리")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("\(selectedHole.distance)m")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 홀 이미지 뷰
    private var holeImageView: some View {
        Group {
            if let holeImageUrl = selectedHole.holeImage, !holeImageUrl.isEmpty {
                AsyncImage(url: URL(string: holeImageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                } placeholder: {
                    placeholderHoleView
                }
            } else {
                placeholderHoleView
            }
        }
        .shadow(radius: 15, x: 0, y: 8)
    }
    
    private var placeholderHoleView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.4), Color.green.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.green.opacity(0.6), lineWidth: 2)
                )
            
            VStack(spacing: 15) {
                Image(systemName: "flag.filled")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .shadow(radius: 3)
                
                Text("\(selectedHole.num)번 홀")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .shadow(radius: 2)
                
                Text("파 \(selectedHole.par)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .shadow(radius: 1)
            }
        }
    }
    
    // MARK: - 풍향 풍속 뷰
    private var windInfoView: some View {
        VStack(spacing: 8) {
            Text("풍향")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                // 애니메이션된 원형 배경
                AnimatedCircleBackground(color: .blue, size: 80)
                
                // 향상된 눈금
                EnhancedTickMarks(color: .blue, size: 80)
                
                // 커스텀 풍향 화살표
                WindArrow(direction: getWindArrowRotation(), size: 50)
            }
            
            if let weather = weatherService.weatherData {
                Text("\(String(format: "%.1f", weather.windSpeed)) m/s")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - 나침반 뷰
    private var compassView: some View {
        VStack(spacing: 8) {
            Text("방향")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ZStack {
                // 애니메이션된 원형 배경
                AnimatedCircleBackground(color: .orange, size: 80)
                
                // 향상된 눈금
                EnhancedTickMarks(color: .orange, size: 80)
                
                // 커스텀 나침반 바늘
                CompassNeedle(heading: locationManager.heading?.trueHeading ?? 0, size: 50)
            }
            
            if let heading = locationManager.heading {
                Text("\(String(format: "%.0f", heading.trueHeading))°")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground).opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Helper Methods
    private func getWindArrowRotation() -> Double {
        guard let weather = weatherService.weatherData else { return 0 }
        
        switch weather.windDirection {
        case "북":
            return 0
        case "북동":
            return 45
        case "동":
            return 90
        case "남동":
            return 135
        case "남":
            return 180
        case "남서":
            return 225
        case "서":
            return 270
        case "북서":
            return 315
        default:
            return 0
        }
    }
    
    private func loadWeatherData() {
        weatherService.fetchWeatherData(for: selectedGolfCourse.coordinate)
    }
}

#Preview {
    MainHoleView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        selectedHole: GolfCourse.sampleData.courses[0].holes[0],
        selectedGolfCourse: GolfCourse.sampleData
    )
}
