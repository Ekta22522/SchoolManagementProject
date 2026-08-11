import Foundation

struct LoginServerAPI: LoginProtocol {
    
    
    
    func login(req: LoginRequest) async throws -> LoginResponse {
        do {
            let response: LoginResponse = try await APIClient.shared.request(APIEndpoint.login, body: req)
            return response
        }
        catch let error {
            debugPrint("error: \(error)")
            throw error
        }
    }

    
    
    
//    func login(req: LoginRequest) async throws -> LoginResponse {
//
//        do {
//
//            guard let url = URL(string: "http://localhost:3000/api/users/login") else {
//                throw URLError(.badURL)
//            }
//
//            
//            // request builder
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//            request.httpBody = try JSONEncoder().encode(req)
//            
//            
//
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw URLError(.badServerResponse)
//            }
//
//            print("Status Code:", httpResponse.statusCode)
//
//            // Print raw JSON returned from server
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON:")
//                print(jsonString)
//            }
//
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//
//            let loginResponse = try decoder.decode(LoginResponse.self, from: data)
//
//            print("Decoded Successfully")
//            print(loginResponse)
//
//            return loginResponse
//
//        } catch let decodingError as DecodingError {
//
//            print("❌ Decoding Error:")
//
//            switch decodingError {
//            case .keyNotFound(let key, let context):
//                print("Missing key:", key.stringValue)
//                print(context.debugDescription)
//
//            case .typeMismatch(let type, let context):
//                print("Type mismatch:", type)
//                print(context.debugDescription)
//
//            case .valueNotFound(let type, let context):
//                print("Value not found:", type)
//                print(context.debugDescription)
//
//            case .dataCorrupted(let context):
//                print("Data corrupted:", context.debugDescription)
//
//            @unknown default:
//                print(decodingError)
//            }
//
//            throw decodingError
//
//        } catch {
//
//            print("❌ Error:", error.localizedDescription)
//            throw error
//        }
//    }
}
