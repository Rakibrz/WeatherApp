//
//  APIManager.swift
//  WeatherApp
//
//  Created by Rakib Rz  on 02-06-2024.
//

import Foundation
import os

class APIManager {
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: APIManager.self))

    func call<GenericType: Decodable>(using urlRequest: URLRequest, responseType: GenericType.Type, showLogs: Bool = false) async -> Result<GenericType, Error> {
        
        let response = await call(request: urlRequest, showLogs: showLogs)
        
        switch response {
        case .success(let data):
            
            guard data.isEmpty == false else {
                /// Handle empty data response
                return await MainActor.run {
                    return .failure(URLError(.cannotDecodeContentData))
                }
            }
            
            let decoding = data.decodeTo(classType: GenericType.self)
            if let model = decoding.model  {
                return await MainActor.run {
                    return .success(model)
                }
            } else if let error = decoding.error {
                return await MainActor.run {
                    return .failure(error)
                }
            }

            return await MainActor.run {
                return .failure(URLError(.cannotDecodeContentData))
            }

        case .failure(let error):
            return await MainActor.run {
                return .failure(error)
            }
        }
    }
    
    func call(request: URLRequest, showLogs: Bool = false) async -> Result<Data, Error> {
        do {
            if showLogs {
                print("=========================")
                logger.trace("URL Method: \(request.httpMethod ?? "-") -> \(request.url?.absoluteString ?? "Unknown")")
            }
            
            logger.info("API called /\(request.url?.lastPathComponent ?? "") at \(Date.now.formatted(date: .omitted, time: .complete))")
            let (data, urlResponse) = try await Task(priority: .background) { () -> (Data, URLResponse) in
                try await URLSession.shared.data(for: request)
            }.value
            logger.info("API responded /\(request.url?.lastPathComponent ?? "") at \(Date.now.formatted(date: .omitted, time: .complete))")
            
            let response = urlResponse as? HTTPURLResponse
            let statusCode = response?.statusCode ?? .zero
            let isValidStatus = isStatusCodeValid(code: statusCode)
            logger.info("Status Code of /\(response?.url?.lastPathComponent ?? "") -> \(statusCode) \(isValidStatus ? "✅" : "❌")")
            let printLogs = showLogs == false ? !isValidStatus : showLogs
            if printLogs {
                logger.log(level: isValidStatus ? .debug : .error, "Response Data of <\(request.httpMethod?.uppercased() ?? "")> /\(response?.url?.lastPathComponent ?? "") \(isValidStatus ? "🟢" : "🟠") -> \(data.toJSON())")
                print("=========================")
            }
            if isValidStatus {
                return await MainActor.run {
                    return .success(data)
                }
            }
            
            return await MainActor.run {
                return .success(data)
            }
        } catch {
            logger.error("Error ⚠️ /\(request.url?.lastPathComponent ?? "") -> \(error.localizedDescription)")
            print("=========================")
            return await MainActor.run {
                return .failure(error)
            }
        }
    }
}

private extension APIManager {
    func isStatusCodeValid(code: Int) -> Bool {
        return (code > 199 && code < 300)
    }
}
