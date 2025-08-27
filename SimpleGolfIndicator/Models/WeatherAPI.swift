import Foundation

// MARK: - OpenWeather API Response Models
struct OpenWeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
    let coord: Coordinates
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Double
    let gust: Double?
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}

// MARK: - App Weather Data Model
struct WeatherData {
    let temperature: Double
    let windDirection: String
    let windSpeed: Double
    let humidity: Double
    let description: String
    let feelsLike: Double
    
    init(from openWeather: OpenWeatherResponse) {
        self.temperature = openWeather.main.temp - 273.15 // Kelvin to Celsius
        self.windDirection = Self.getWindDirection(openWeather.wind.deg)
        self.windSpeed = openWeather.wind.speed
        self.humidity = Double(openWeather.main.humidity)
        self.description = openWeather.weather.first?.description ?? "맑음"
        self.feelsLike = openWeather.main.feels_like - 273.15
    }
    
    private static func getWindDirection(_ degrees: Double) -> String {
        let normalizedDegrees = degrees.truncatingRemainder(dividingBy: 360)
        let positiveDegrees = normalizedDegrees < 0 ? normalizedDegrees + 360 : normalizedDegrees
        
        switch positiveDegrees {
        case 0..<22.5, 337.5..<360:
            return "북"
        case 22.5..<67.5:
            return "북동"
        case 67.5..<112.5:
            return "동"
        case 112.5..<157.5:
            return "남동"
        case 157.5..<202.5:
            return "남"
        case 202.5..<247.5:
            return "남서"
        case 247.5..<292.5:
            return "서"
        case 292.5..<337.5:
            return "북서"
        default:
            return "북"
        }
    }
}
