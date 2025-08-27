import Foundation

struct AppConfig {
    // MARK: - API URLs
    static let golfCourseDataURL = "https://your-s3-bucket.s3.amazonaws.com/course.json"
    // 또는 Google Drive 공유 링크
    // static let golfCourseDataURL = "https://drive.google.com/uc?export=download&id=YOUR_FILE_ID"
    
    // MARK: - OpenWeather API
    static let openWeatherAPIKey = "YOUR_OPENWEATHER_API_KEY" // 여기에 실제 API 키를 입력하세요
    static let openWeatherBaseURL = "https://api.openweathermap.org/data/2.5"
    
    // MARK: - Fallback URLs (백업용)
    static let fallbackURLs = [
        "https://backup-server.com/course.json",
        "https://alternative-cdn.com/course.json"
    ]
    
    // MARK: - Cache Settings
    static let cacheExpirationTime: TimeInterval = 3600 // 1시간
    static let weatherCacheExpirationTime: TimeInterval = 1800 // 30분
    
    // MARK: - Network Settings
    static let requestTimeout: TimeInterval = 30.0
    static let maxRetryCount = 3
    
    // MARK: - Debug Settings
    static let isDebugMode = true
    static let enableLogging = true
}
