//
//  WeatherScreenView.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import SwiftUI

struct WeatherScreenView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @AppStorage(StorageKey.recentCityName.rawValue) private var currentLocation: String?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                
                TextField("Enter city name", text: $viewModel.cityName)
                    .textContentType(.addressCity)
                    .submitLabel(.search)
            }
            .padding()
            .background(Color.theme.pinkLight.opacity(0.1))
            .cornerRadius(8)
            .padding()
            .onSubmit {
                Task {
                    await viewModel.fetchWeather()
                    currentLocation = viewModel.model?.locationName()
                }
            }

            VStack(spacing: 8) {
                if viewModel.cityName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Search for a city to access the weather information.")
                        .font(.body)
                } 
                else if let model = viewModel.model {
                    if let currentLocation {
                        Text(currentLocation)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }
                    
                    if let value = model.main?.temp?.formatted() {
                        Text(value)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    
                    if let value = model.weather?.first?.description?.capitalized {
                        Text(value)
                            .font(.title)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let message = model.message {
                        Text(message.capitalized)
                            .foregroundStyle(.red)
                    }
                }
            }
            .foregroundColor(.theme.pinkLight)
            .padding()
            .frame(minWidth: UIScreen.main.bounds.width * 0.6)
            .background(Color.theme.pinkLight.opacity(0.1))
            .cornerRadius(12)
            .padding()

            Image("House")
                .frame(maxHeight: .infinity, alignment: .bottom)
                .ignoresSafeArea(edges: .bottom)
        }
        .background {
            LinearGradient(gradient: Gradient(colors: Array(Color.theme.linearIndigoDark)),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea(edges: .all)
        }
        .ignoresSafeArea(.keyboard)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .alert("Error", isPresented: $viewModel.showError, actions: {
            Button("OK") { }
        }, message: {
            Text(viewModel.errorMessage ?? "Unknown")
        })
        .task {
            SharedManager.shared.fetchServices()
        }
    }
}

#Preview {
    WeatherScreenView()
}
