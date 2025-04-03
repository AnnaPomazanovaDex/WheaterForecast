import Foundation

// Geocoding Response Models
struct GeocodingResponse: Codable {
    let results: [Location]
}

struct Location: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
}

// Weather Response Models
struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let current_weather: CurrentWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let weathercode: [Int]
}

// Weather Code Helper
enum WeatherCode {
    static func description(for code: Int) -> (description: String, systemImage: String) {
        switch code {
        case 0:
            return ("Clear sky", "sun.max.fill")
        case 1, 2, 3:
            return ("Partly cloudy", "cloud.sun.fill")
        case 45, 48:
            return ("Foggy", "cloud.fog.fill")
        case 51, 53, 55:
            return ("Drizzle", "cloud.drizzle.fill")
        case 61, 63, 65:
            return ("Rain", "cloud.rain.fill")
        case 71, 73, 75:
            return ("Snow", "cloud.snow.fill")
        case 77:
            return ("Snow grains", "cloud.snow.fill")
        case 80, 81, 82:
            return ("Rain showers", "cloud.heavyrain.fill")
        case 85, 86:
            return ("Snow showers", "cloud.snow.fill")
        case 95:
            return ("Thunderstorm", "cloud.bolt.fill")
        case 96, 99:
            return ("Thunderstorm with hail", "cloud.bolt.rain.fill")
        default:
            return ("Unknown", "questionmark.circle.fill")
        }
    }
} 