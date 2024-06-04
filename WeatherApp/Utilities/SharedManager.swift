//
//  SharedManager.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation

@MainActor
class SharedManager: ObservableObject {
    static let shared: SharedManager = SharedManager()

    @Published var weatherService: WeatherService?

    func fetchServices() {
        // Read API domain and path from the plist file.
        guard let url = Bundle.main.url(forResource: "WeatherServices", withExtension: "plist") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = PropertyListDecoder()
            weatherService = try decoder.decode(WeatherService.self, from: data)
        } catch let error {
            print("\(#function) Error: \(error.localizedDescription)")
        }
    }
}

enum StorageKey: String {
    case recentCityName
}
