//
//  Codable+Extensions.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation
import os

extension Data {
    func decodeTo<GenericType: Decodable>(classType: GenericType.Type) -> (model: GenericType?, error: Error?) {
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let decodable = try decoder.decode(classType, from: self)
            return (decodable, nil)
        } catch {
            Logger().fault("Getting error while \(#function): \(String(describing: GenericType.self))... \(error.localizedDescription)")
            Logger().notice("\(#function) Data: \(self.toJSON())")
            return (nil, error)
        }
    }
    
    func toJSON() -> String {
        return String(bytes: self, encoding: String.Encoding.utf8) ?? "invalid data"
    }
    
    func toDictionary() -> [String: Any] {
        let dictionary = try? JSONSerialization.jsonObject(with: self, options: [.allowFragments]) as? [String: Any]
        return dictionary ?? [:]
    }
}
