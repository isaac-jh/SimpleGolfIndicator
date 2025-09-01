import Foundation

// MARK: - 앱 설정
struct AppConfig {
    // MARK: - Weather API Settings
    static let weatherAPIKey = "YOUR_WEATHER_API_KEY" // OpenWeatherMap API 키
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // MARK: - Debug Settings
    static let isDebugMode = false
    static let enableLogging = false
}
