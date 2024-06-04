//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation


class WeatherViewModel: ObservableObject {
    
    @Published var cityName: String = ""

    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    @Published private(set) var model: Weather?

    private let apiManager: APIManager = APIManager()

    @MainActor
    func fetchWeather() async {
        guard cityName.isEmpty == false else {
            errorMessage = "City name cannot be empty."
            showError = true
            return
        }

        guard var urlComponent: URLComponents = SharedManager.shared.weatherService?.getUrlComponents() else { return }
        
        urlComponent.queryItems?.append(URLQueryItem(name: "q", value: cityName))
        
        guard let url = urlComponent.url else { return }
        isLoading = true
        errorMessage = .none
        defer { isLoading = false }
        
        let urlRequest: URLRequest = URLRequest(url: url)
        let result = await apiManager.call(using: urlRequest, responseType: Weather.self, showLogs: true)
        switch result {
        case .success(let success):
            model = success
            print(success)
        case .failure(let failure):
            errorMessage = failure.localizedDescription
            showError = true
        }
    }
}
