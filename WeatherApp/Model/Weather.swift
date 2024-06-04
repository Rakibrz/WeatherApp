//
//  Weather.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation

struct Weather: Decodable, Identifiable {
    let id: Double?
    let name: String?
    let coord: Coordinator?
    let main: Temperature?
    let weather: [WeatherDetail]?
    let sys: Country?
    let message: String?
}

extension Weather {
    func locationName() -> String? {
        var value: String = name?.trimmingCharacters(in: .whitespacesAndNewlines) ?? String()
        
        if value.isEmpty == false {
            value.append(", ")
        }
        if let country = sys?.country {
            value.append(country)
        }
        value = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? .none : value
    }
}

struct Coordinator: Decodable {
    let lat, lon: Double?
}

struct Temperature: Decodable {
    let temp, humidity: Double?
}

struct WeatherDetail: Decodable {
    let id: Double?
    let main, description: String?
}

struct Country: Decodable {
    let country: String?
}
