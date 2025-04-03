import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        Logger.network("🔎 Starting weather fetch for city: \(city)")
        
        // First get coordinates for the city
        let geocodingURL = "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&count=1&language=en&format=json"
        
        guard let url = URL(string: geocodingURL) else {
            Logger.error("❌ Invalid geocoding URL for city: \(city)")
            throw NetworkError.invalidURL
        }
        
        Logger.location("🌍 Fetching coordinates for: \(city)")
        let (geoData, geoResponse) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = geoResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            Logger.error("🚫 Invalid geocoding response for city: \(city)")
            throw NetworkError.invalidResponse
        }
        
        let geoResult = try JSONDecoder().decode(GeocodingResponse.self, from: geoData)
        
        guard let location = geoResult.results.first else {
            Logger.error("📍 No location found for city: \(city)")
            throw NetworkError.invalidData
        }
        
        Logger.location("✅ Found coordinates: \(location.latitude), \(location.longitude)")
        
        // Now get weather data using coordinates
        let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=auto"
        
        guard let weatherRequestURL = URL(string: weatherURL) else {
            Logger.error("❌ Invalid weather URL for coordinates")
            throw NetworkError.invalidURL
        }
        
        Logger.weather("☁️ Fetching weather data for: \(city)")
        let (weatherData, weatherResponse) = try await URLSession.shared.data(from: weatherRequestURL)
        
        guard let httpWeatherResponse = weatherResponse as? HTTPURLResponse,
              httpWeatherResponse.statusCode == 200 else {
            Logger.error("🚫 Invalid weather response for coordinates")
            throw NetworkError.invalidResponse
        }
        
        let weatherResult = try JSONDecoder().decode(WeatherResponse.self, from: weatherData)
        Logger.success("🌈 Successfully fetched weather data for: \(city)")
        return weatherResult
    }
}

