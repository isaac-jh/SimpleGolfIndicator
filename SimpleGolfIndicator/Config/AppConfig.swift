import Foundation

struct AppConfig {
    // MARK: - API URLs
    static let golfCourseDataURL = "https://your-s3-bucket.s3.amazonaws.com/course.json"
    // 또는 Google Drive 공유 링크
    // static let golfCourseDataURL = "https://drive.google.com/uc?export=download&id=YOUR_FILE_ID"
    
    // MARK: - Fallback URLs (백업용)
    static let fallbackURLs = [
        "https://backup-server.com/course.json",
        "https://alternative-cdn.com/course.json"
    ]
    
    // MARK: - Cache Settings
    static let cacheExpirationTime: TimeInterval = 3600 // 1시간
    
    // MARK: - Network Settings
    static let requestTimeout: TimeInterval = 30.0
    static let maxRetryCount = 3
    
    // MARK: - Debug Settings
    static let isDebugMode = true
    static let enableLogging = true
}
