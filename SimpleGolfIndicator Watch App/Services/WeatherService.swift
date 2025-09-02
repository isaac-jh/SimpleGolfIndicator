import Foundation
import Combine

// MARK: - 날씨 데이터 서비스
class WeatherService: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    /// 테스트용 더미 날씨 데이터를 생성합니다
    private func createDummyWeatherData() -> CurrentWeather {
        return CurrentWeather(
            dt: Int(Date().timeIntervalSince1970),
            sunrise: 0,
            sunset: 0,
            temp: 20.0,
            feelsLike: 22.0,
            pressure: 1013,
            humidity: 65,
            dewPoint: 15.0,
            uvi: 0.5,
            clouds: 30,
            visibility: 10000,
            windSpeed: 5.2,
            windDeg: 180.0,
            windGust: 8.0,
            weather: [
                WeatherDescription(id: 800, main: "Clear", description: "맑음", icon: "01d")
            ]
        )
    }
    
    /// 날씨 데이터를 가져옵니다
    /// - Parameters:
    ///   - latitude: 위도
    ///   - longitude: 경도
    func fetchWeatherData(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        // TODO: API 키 권한 문제로 인해 현재는 더미 데이터 사용
        // 실제 구현 시에는 아래 주석 처리된 코드를 사용
        /*
        // URL 구성
        var components = URLComponents(string: AppConfig.weatherRequestURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "exclude", value: "minutely,hourly,daily,alerts"),
            URLQueryItem(name: "appid", value: AppConfig.weatherAPIKey)
        ]
        
        guard let url = components?.url else {
            errorMessage = "잘못된 URL입니다"
            isLoading = false
            return
        }
        
        // 네트워크 요청
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "날씨 데이터 가져오기 실패: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] weatherResponse in
                    self?.currentWeather = weatherResponse.current
                }
            )
            .store(in: &cancellables)
        */
        
        // 더미 데이터 사용 (테스트용)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.currentWeather = self?.createDummyWeatherData()
            self?.isLoading = false
        }
    }
    
    /// 10분마다 날씨 데이터를 자동으로 업데이트합니다
    /// - Parameters:
    ///   - latitude: 위도
    ///   - longitude: 경도
    func startAutoRefresh(latitude: Double, longitude: Double) {
        // 즉시 첫 번째 요청
        fetchWeatherData(latitude: latitude, longitude: longitude)
        
        // 10분마다 자동 업데이트 (테스트용으로는 30초마다)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.fetchWeatherData(latitude: latitude, longitude: longitude)
        }
    }
    
    /// 자동 업데이트를 중지합니다
    func stopAutoRefresh() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopAutoRefresh()
    }
}
