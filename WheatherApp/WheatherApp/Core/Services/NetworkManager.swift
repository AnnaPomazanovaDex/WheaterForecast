import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {
        KeyManager.shared.saveKeyInsecure(key: "apiKey", value: "1234567890abcdef")
    }
    
    func fetchWeather(city: String) async throws -> WeatherResponse {
        // First get coordinates for the city
        let geocodingURL = "https://geocoding-api.open-meteo.com/v1/search?name=\(city)&count=1&language=en&format=json"
        
        guard let url = URL(string: geocodingURL) else {
            throw NetworkError.invalidURL
        }
        
        let (geoData, geoResponse) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = geoResponse as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let geoResult = try JSONDecoder().decode(GeocodingResponse.self, from: geoData)
        
        guard let location = geoResult.results.first else {
            throw NetworkError.invalidData
        }
        
        // Now get weather data using coordinates
        let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&daily=temperature_2m_max,temperature_2m_min,weathercode&current_weather=true&timezone=auto"
        
        guard let weatherRequestURL = URL(string: weatherURL) else {
            throw NetworkError.invalidURL
        }
        
        let (weatherData, weatherResponse) = try await URLSession.shared.data(from: weatherRequestURL)
        
        guard let httpWeatherResponse = weatherResponse as? HTTPURLResponse,
              httpWeatherResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        let weatherResult = try JSONDecoder().decode(WeatherResponse.self, from: weatherData)
        return weatherResult
    }
} 
