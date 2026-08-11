//
//  APIClient.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/08/2026.
//
import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse
    case decodingFailed
    case serverError(Int)
    case unauthorized
    case noInternet
    case unknown(Error)

}

final class APIClient{
    
     static let shared = APIClient()
    
    private init (){}
    
    func request<T : Decodable>(
        _ endPoint: APIEndpoint,
        body:Encodable? = nil
    )async throws -> T {
        var request  = RequestBuilder.build(for: endPoint)
        
        if let body {
            
            let requestBody = try JSONEncoder().encode(body)
//            debugPrint("requestBody: \(requestBody)")
            request.httpBody = requestBody
        }
        
        let (data, response) = try await URLSession.shared.data(for:request)
        
//        debugPrint("response: \(response)")
//        debugPrint("data: \(data)")
        
        guard let response = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        
        guard 200...299 ~= response.statusCode else{
            throw NetworkError.serverError(response.statusCode)
        }
        
        return try JSONDecoder().decode(T.self,from: data)
    }
}
