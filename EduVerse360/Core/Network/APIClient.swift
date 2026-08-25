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
    
    func request<T: Decodable>(
        _ endPoint: APIEndpoint,
        body: Encodable? = nil
    ) async throws -> T {
        
        do {
            var request = RequestBuilder.build(for: endPoint)
            
            print("🌐 URL:", request.url?.absoluteString ?? "NO URL")
            print("📤 METHOD:", request.httpMethod ?? "NO METHOD")
            
            if let body {
                let encoder = JSONEncoder()
                let requestBody = try encoder.encode(body)
                
                request.httpBody = requestBody
                
                print("📦 REQUEST BODY:",
                      String(data: requestBody, encoding: .utf8) ?? "Could not print body")
            }
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("📥 RAW RESPONSE:",
                  String(data: data, encoding: .utf8) ?? "Could not read response")
            
            guard let response = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response")
                throw NetworkError.invalidResponse
            }
            
            print("📡 STATUS CODE:", response.statusCode)
            
            guard 200...299 ~= response.statusCode else {
                print("❌ SERVER ERROR:", response.statusCode)
                
                throw NetworkError.serverError(response.statusCode)
            }
            
            do {
                let decoder = JSONDecoder()
                
                let decodedData = try decoder.decode(T.self, from: data)
                
                print("✅ DECODING SUCCESS")
                
                return decodedData
                
            } catch {
                print("❌ DECODING ERROR:", error)
                print("❌ DECODING ERROR DESCRIPTION:", error.localizedDescription)
                
                throw NetworkError.decodingFailed
            }
            
        } catch {
            print("🔥 API ERROR:", error)
            print("🔥 API ERROR DESCRIPTION:", error.localizedDescription)
            
            throw error
        }
    }
}
