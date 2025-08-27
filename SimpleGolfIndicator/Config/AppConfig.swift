import Foundation

struct AppConfig {
    // MARK: - API URLs
    static let golfCourseDataURL = "https://your-s3-bucket.s3.amazonaws.com/course.json"
    
    // MARK: - OpenWeather API
    static let openWeatherAPIKey = "YOUR_OPENWEATHER_API_KEY"
    static let openWeatherBaseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: - Cache Settings
    static let cacheExpirationTime: TimeInterval = 3600 // 1시간
    static let weatherCacheExpirationTime: TimeInterval = 1800 // 30분
    
    // MARK: - Network Settings
    static let requestTimeout: TimeInterval = 30.0
    
    // MARK: - Debug Settings
    static let isDebugMode = true
    static let enableLogging = true
}
