//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation

// https://home.openweathermap.org/api_keys

/* Used to hold backend useful data */
struct WeatherService: Decodable {
    let host, path, apiKey: String
}

extension WeatherService {
    func getUrlComponents() -> URLComponents {
        var urlComponents: URLComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [URLQueryItem(name: "appId", value: apiKey)]
        return urlComponents
    }
}
