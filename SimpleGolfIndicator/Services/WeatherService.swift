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
        let urlString = "\(AppConfig.weatherBaseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(AppConfig.weatherAPIKey)&units=metric&lang=kr"
        
        guard let url = URL(string: urlString) else {
            handleError("잘못된 URL입니다")
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 30.0 // 기본 타임아웃
        
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
        if timeSinceCache > 1800 { // 30분
            cache.removeObject(forKey: key as NSString)
            return nil
        }
        
        return cachedData
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

// MARK: - Weather Data Models
struct WeatherData {
    let temperature: Double
    let humidity: Int
    let windSpeed: Double
    let windDirection: Int
    let description: String
    
    var rawWindDegrees: Double {
        Double(windDirection)
    }
    
    init(from response: OpenWeatherResponse) {
        self.temperature = response.main.temp
        self.humidity = response.main.humidity
        self.windSpeed = response.wind.speed
        self.windDirection = response.wind.deg
        self.description = response.weather.first?.description ?? ""
    }
}

struct OpenWeatherResponse: Codable {
    let main: MainWeather
    let wind: Wind
    let weather: [WeatherDescription]
}

struct MainWeather: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct WeatherDescription: Codable {
    let description: String
}
