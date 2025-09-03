import Foundation

struct CurrentWeather: Codable {
    let windSpeed: Double
    let windDeg: Double
    
    enum CodingKeys: String, CodingKey {
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
    }
}

// MARK: - OpenWeather 2.5/weather (wind only)
struct WeatherNowResponse: Codable {
    let wind: Wind
    
    struct Wind: Codable {
        let speed: Double
        let deg: Double
    }
}
