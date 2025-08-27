import SwiftUI
import CoreLocation

struct WeatherView: View {
    let selectedCourse: Course
    @State private var weatherData: WeatherData?
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // 골프장 정보 표시
                VStack(spacing: 8) {
                    Text(selectedCourse.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // 부모 골프장의 위치 정보를 표시하려면 추가 구조가 필요
                    Text("위치 정보")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                if isLoading {
                    ProgressView("날씨 정보 로딩 중...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let weather = weatherData {
                    weatherInfoView(weather)
                } else {
                    noDataView
                }
            }
            .padding()
        }
        .navigationTitle("날씨 정보")
        .onAppear {
            loadWeatherData()
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
    
    private func weatherInfoView(_ weather: WeatherData) -> some View {
        VStack(spacing: 15) {
            // 온도 정보
            HStack {
                Image(systemName: "thermometer")
                    .foregroundColor(.red)
                Text("\(Int(weather.temperature))°C")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // 풍향 정보
            HStack {
                Image(systemName: "wind")
                    .foregroundColor(.blue)
                Text("풍향: \(weather.windDirection)")
                    .font(.body)
            }
            
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
                Text(getGolfImpact(weather))
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private func getGolfImpact(_ weather: WeatherData) -> String {
        if weather.windSpeed > 10 {
            return "강풍으로 인해 공의 궤적에 큰 영향"
        } else if weather.windSpeed > 5 {
            return "중간 바람으로 인해 공의 궤적에 영향"
        } else {
            return "약한 바람으로 인해 공의 궤적에 적은 영향"
        }
    }
    
    private func loadWeatherData() {
        isLoading = true
        
        // 실제 날씨 API 호출 대신 샘플 데이터 사용
        // 실제 구현 시에는 골프장의 위치 정보를 사용하여 API 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            weatherData = WeatherData(
                temperature: 22.5,
                windDirection: "북동",
                windSpeed: 3.2,
                humidity: 65
            )
            isLoading = false
        }
    }
}

struct WeatherData {
    let temperature: Double
    let windDirection: String
    let windSpeed: Double
    let humidity: Double
}

#Preview {
    WeatherView(selectedCourse: GolfCourse.sampleData.courses[0])
}
