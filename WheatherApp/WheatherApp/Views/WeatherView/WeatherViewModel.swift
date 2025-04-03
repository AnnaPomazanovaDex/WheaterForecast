import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: DailyWeather?
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchWeather(for city: String) {
        Logger.debug("🎯 Starting weather fetch for: \(city)")
        isLoading = true
        error = nil
        
        Task {
            do {
                Logger.info("🔄 Fetching weather data for: \(city)")
                let response = try await NetworkManager.shared.fetchWeather(city: city)
                currentWeather = response.current_weather
                dailyWeather = response.daily
                cityName = city
                error = nil
                Logger.success("✨ Successfully updated weather for: \(city)")
                
                // Log current conditions
                if let current = currentWeather {
                    let weatherInfo = WeatherCode.description(for: current.weathercode)
                    Logger.weather("""
                        🌡️ Current conditions for \(city):
                        Temperature: \(formatTemperature(current.temperature))
                        Weather: \(weatherInfo.description) \(weatherInfo.systemImage)
                        Wind Speed: \(current.windspeed) km/h 💨
                        """)
                }
            } catch {
                self.error = error.localizedDescription
                Logger.error("💥 Failed to fetch weather: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    func formatTemperature(_ temp: Double) -> String {
        return "\(Int(round(temp)))°"
    }
    
    func formatDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "EEE"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

