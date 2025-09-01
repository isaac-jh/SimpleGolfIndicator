import Foundation

// MARK: - 앱 설정
struct AppConfig {
    // MARK: - Weather API Settings
    static let weatherAPIKey = "6a61d141678b423b0438629096b80f97" // OpenWeatherMap API 키
    static let weatherBaseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    // MARK: - Debug Settings
    static let isDebugMode = false
    static let enableLogging = false
}
