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
    let rawWindDegrees: Double // 원본 풍향 각도 (부드러운 회전용)
    
    init(from openWeather: OpenWeatherResponse) {
        self.temperature = openWeather.main.temp - 273.15 // Kelvin to Celsius
        self.rawWindDegrees = openWeather.wind.deg
        self.windDirection = Self.getWindDirection(openWeather.wind.deg)
        self.windSpeed = openWeather.wind.speed
        self.humidity = Double(openWeather.main.humidity)
        self.description = openWeather.weather.first?.description ?? "맑음"
        self.feelsLike = openWeather.main.feels_like - 273.15
    }
    
    private static func getWindDirection(_ degrees: Double) -> String {
        return DirectionUtils.getDetailedDirectionName(degrees)
    }
}
