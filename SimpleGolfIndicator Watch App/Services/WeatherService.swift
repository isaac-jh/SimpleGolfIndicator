import Foundation
import Combine

// MARK: - 날씨 데이터 서비스
class WeatherService: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    
    /// 날씨 데이터를 가져옵니다
    /// - Parameters:
    ///   - latitude: 위도
    ///   - longitude: 경도
    func fetchWeatherData(latitude: Double, longitude: Double) {
        isLoading = true
        errorMessage = nil
        
        // URL 구성 (OpenWeather 2.5/weather)
        var components = URLComponents(string: AppConfig.weatherRequestURL)
        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: AppConfig.weatherAPIKey)
        ]
        
        guard let url = components?.url else {
            errorMessage = "잘못된 URL입니다"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { result -> Data in
                guard let http = result.response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: WeatherNowResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = "날씨 데이터 가져오기 실패: \(error.localizedDescription)"
                    }
                },
                receiveValue: { [weak self] response in
                    // 필요한 값만 CurrentWeather로 매핑
                    let mapped = CurrentWeather(
                        windSpeed: response.wind.speed,
                        windDeg: response.wind.deg
                    )
                    self?.currentWeather = mapped
                }
            )
            .store(in: &cancellables)
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
        timer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
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
