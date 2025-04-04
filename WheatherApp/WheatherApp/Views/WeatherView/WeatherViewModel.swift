import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: DailyWeather?
    @Published var cityName: String = ""
    @Published var isLoading = false
    @Published var error: String?
    
    func fetchWeather(for city: String) {
        isLoading = true
        error = nil
        
        Task {
            do {
                let response = try await NetworkManager.shared.fetchWeather(city: city)
                currentWeather = response.current_weather
                dailyWeather = response.daily
                cityName = city
                error = nil
            } catch {
                self.error = error.localizedDescription
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