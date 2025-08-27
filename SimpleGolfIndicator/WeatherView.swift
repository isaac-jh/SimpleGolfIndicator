import SwiftUI
import CoreLocation

struct WeatherView: View {
    let selectedCourse: Course
    let golfCourse: GolfCourse // 부모 골프장 정보를 받아야 함
    
    @StateObject private var weatherService = WeatherService()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // 골프장 정보 표시
                VStack(spacing: 8) {
                    Text(golfCourse.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(selectedCourse.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("위도: \(String(format: "%.4f", golfCourse.location.latitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("경도: \(String(format: "%.4f", golfCourse.location.longitude))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                if weatherService.isLoading {
                    ProgressView("날씨 정보 로딩 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = weatherService.error {
                    errorView(error)
                } else if let weather = weatherService.weatherData {
                    weatherInfoView(weather)
                } else {
                    noDataView
                }
                
                // 새로고침 버튼
                Button(action: {
                    weatherService.refreshWeatherData(for: golfCourse.coordinate)
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("새로고침")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("날씨 정보")
        .onAppear {
            loadWeatherData()
            locationManager.startUpdatingHeading()
        }
        .onDisappear {
            locationManager.stopUpdatingHeading()
        }
    }
    
    private var noDataView: some View {
        VStack(spacing: 10) {
            Image(systemName: "cloud.slash")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            Text("날씨 정보를 불러올 수 없습니다")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("네트워크 연결을 확인해주세요")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private func errorView(_ error: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
            
            Text("날씨 정보 로딩 실패")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(error)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private func weatherInfoView(_ weather: WeatherData) -> some View {
        VStack(spacing: 15) {
            // 날씨 설명
            HStack {
                Image(systemName: "cloud.sun.fill")
                    .foregroundColor(.yellow)
                Text(weather.description)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            // 온도 정보
            HStack {
                Image(systemName: "thermometer")
                    .foregroundColor(.red)
                Text("\(String(format: "%.1f", weather.temperature))°C")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // 체감 온도
            HStack {
                Image(systemName: "thermometer.snowflake")
                    .foregroundColor(.blue)
                Text("체감 온도: \(String(format: "%.1f", weather.feelsLike))°C")
                    .font(.body)
            }
            
            // 풍향 정보 (부드러운 회전)
            VStack(spacing: 10) {
                Text("풍향")
                    .font(.headline)
                
                ZStack {
                    // 외부 원
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                    
                    // 4방향 메인 표시
                    ForEach(0..<4) { index in
                        let angle = Double(index) * 90.0
                        let direction = getMainDirectionName(angle)
                        
                        Text(direction)
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .offset(y: -65)
                            .rotationEffect(.degrees(angle))
                    }
                    
                    // 풍향 화살표 (부드러운 회전)
                    VStack(spacing: 0) {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                            .rotationEffect(.degrees(getWindArrowRotation(weather.windDirection)))
                        
                        Text("풍향")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                Text("\(weather.windDirection)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            // 풍속 정보
            HStack {
                Image(systemName: "wind.circle")
                    .foregroundColor(.cyan)
                Text("풍속: \(String(format: "%.1f", weather.windSpeed)) m/s")
                    .font(.body)
            }
            
            // 습도 정보
            HStack {
                Image(systemName: "humidity")
                    .foregroundColor(.blue)
                Text("습도: \(Int(weather.humidity))%")
                    .font(.body)
            }
            
            // 골프에 미치는 영향
            golfImpactView(weather)
        }
    }
    
    private func golfImpactView(_ weather: WeatherData) -> some View {
        VStack(spacing: 10) {
            Text("골프 영향도")
                .font(.headline)
                .padding(.top)
            
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                Text(weatherService.getGolfImpact(for: weather))
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private func getMainDirectionName(_ degrees: Double) -> String {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        switch positiveDegrees {
        case 0:
            return "N"
        case 90:
            return "E"
        case 180:
            return "S"
        case 270:
            return "W"
        default:
            return "N"
        }
    }
    
    private func getWindArrowRotation(_ windDirection: String) -> Double {
        switch windDirection {
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
        weatherService.fetchWeatherData(for: golfCourse.coordinate)
    }
}

#Preview {
    WeatherView(
        selectedCourse: GolfCourse.sampleData.courses[0],
        golfCourse: GolfCourse.sampleData
    )
}
