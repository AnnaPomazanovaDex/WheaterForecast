import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.6), .blue.opacity(0.2)]),
                             startPoint: .top,
                             endPoint: .bottom)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                } else if let error = viewModel.error {
                    VStack {
                        Text("Error: \(error)")
                            .foregroundColor(.white)
                            .padding()
                        Button("Try Again") {
                            if !searchText.isEmpty {
                                viewModel.fetchWeather(for: searchText)
                            }
                        }
                        .buttonStyle(.bordered)
                        .tint(.white)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Current Weather Section
                            if let current = viewModel.currentWeather {
                                VStack(spacing: 10) {
                                    Text(viewModel.cityName.uppercased())
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                    Text(viewModel.formatTemperature(current.temperature))
                                        .font(.system(size: 96))
                                        .fontWeight(.thin)
                                        .foregroundColor(.white)
                                    
                                    let weatherInfo = WeatherCode.description(for: current.weathercode)
                                    Text(weatherInfo.description)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    
                                    if let daily = viewModel.dailyWeather {
                                        Text("H:\(viewModel.formatTemperature(daily.temperature_2m_max[0])) L:\(viewModel.formatTemperature(daily.temperature_2m_min[0]))")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.top, 32)
                            }
                            
                            // Hourly Forecast
                            if let daily = viewModel.dailyWeather {
                                VStack(spacing: 15) {
                                    ForEach(0..<min(7, daily.time.count), id: \.self) { index in
                                        HStack {
                                            Text(viewModel.formatDate(daily.time[index]))
                                                .frame(width: 50, alignment: .leading)
                                            
                                            let weatherInfo = WeatherCode.description(for: daily.weathercode[index])
                                            Image(systemName: weatherInfo.systemImage)
                                                .frame(width: 30)
                                            
                                            Spacer()
                                            
                                            Text("L: \(viewModel.formatTemperature(daily.temperature_2m_min[index]))")
                                            Text("H: \(viewModel.formatTemperature(daily.temperature_2m_max[index]))")
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                                .padding()
                                .background(.white.opacity(0.1))
                                .cornerRadius(15)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, isSearching ? 0 : 60)
                    }
                }
            }
            .searchable(text: $searchText,
                       placement: .navigationBarDrawer(displayMode: .always),
                       prompt: "Search for a city")
            .onChange(of: searchText) { oldValue, newValue in
                if !newValue.isEmpty && newValue.count >= 2 {
                    viewModel.fetchWeather(for: newValue)
                }
            }
            .onSubmit(of: .search) {
                if !searchText.isEmpty {
                    viewModel.fetchWeather(for: searchText)
                }
            }
        }
    }
} 