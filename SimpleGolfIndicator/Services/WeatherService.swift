import Foundation
import Combine
import CoreLocation

class WeatherService: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var error: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let cache = NSCache<NSString, CachedWeatherData>()
    
    init() {}
    
    func fetchWeatherData(for location: CLLocationCoordinate2D) {
        isLoading = true
        error = nil
        
        // 캐시된 데이터 확인
        let cacheKey = "\(location.latitude),\(location.longitude)"
        if let cachedData = getCachedWeatherData(for: cacheKey) {
            self.weatherData = cachedData.weatherData
            self.isLoading = false
            return
        }
        
        // OpenWeather API 호출
        fetchFromOpenWeather(latitude: location.latitude, longitude: location.longitude)
    }
    
    private func fetchFromOpenWeather(latitude: Double, longitude: Double) {
        let urlString = "\(AppConfig.openWeatherBaseURL)/weather?lat=\(latitude)&lon=\(longitude)&appid=\(AppConfig.openWeatherAPIKey)&units=metric&lang=kr"
        
        guard let url = URL(string: urlString) else {
            handleError("잘못된 URL입니다")
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = AppConfig.requestTimeout
        
        if AppConfig.enableLogging {
            print("Fetching weather from: \(urlString)")
        }
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: OpenWeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] openWeatherResponse in
                    let weatherData = WeatherData(from: openWeatherResponse)
                    self?.weatherData = weatherData
                    self?.cacheWeatherData(weatherData, for: "\(latitude),\(longitude)")
                    
                    if AppConfig.enableLogging {
                        print("Weather data received: \(weatherData)")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func handleError(_ message: String) {
        error = message
        isLoading = false
        
        if AppConfig.enableLogging {
            print("WeatherService Error: \(message)")
        }
    }
    
    // MARK: - Caching
    private func cacheWeatherData(_ weatherData: WeatherData, for key: String) {
        let cachedData = CachedWeatherData(
            weatherData: weatherData,
            timestamp: Date()
        )
        cache.setObject(cachedData, forKey: key as NSString)
    }
    
    private func getCachedWeatherData(for key: String) -> CachedWeatherData? {
        guard let cachedData = cache.object(forKey: key as NSString) else {
            return nil
        }
        
        // 캐시 만료 확인 (30분)
        let timeSinceCache = Date().timeIntervalSince(cachedData.timestamp)
        if timeSinceCache > AppConfig.weatherCacheExpirationTime {
            cache.removeObject(forKey: key as NSString)
            return nil
        }
        
        return cachedData
    }
    
    // MARK: - Public Methods
    func refreshWeatherData(for location: CLLocationCoordinate2D) {
        let cacheKey = "\(location.latitude),\(location.longitude)"
        cache.removeObject(forKey: cacheKey as NSString)
        fetchWeatherData(for: location)
    }
    
    func getGolfImpact(for weatherData: WeatherData) -> String {
        if weatherData.windSpeed > 10 {
            return "강풍으로 인해 공의 궤적에 큰 영향"
        } else if weatherData.windSpeed > 5 {
            return "중간 바람으로 인해 공의 궤적에 영향"
        } else {
            return "약한 바람으로 인해 공의 궤적에 적은 영향"
        }
    }
}

// MARK: - Cache Data Structure
private class CachedWeatherData {
    let weatherData: WeatherData
    let timestamp: Date
    
    init(weatherData: WeatherData, timestamp: Date) {
        self.weatherData = weatherData
        self.timestamp = timestamp
    }
}
