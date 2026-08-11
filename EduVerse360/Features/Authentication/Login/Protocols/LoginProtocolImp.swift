//
//  LoginMockAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//

import Foundation
import Combine

enum LoginError: LocalizedError {
    case invalidCredentials
    case fieldsAreRequired
    case usernameEmpty
    case passwordEmpty
    case userNotFound
    case PasswordMustBeAtLeast8Characters
    case InvalidJSONFormat
    
}

class LoginMockAPI : LoginProtocol {
    
    
    func login(req: LoginRequest) async throws -> LoginResponse{
        
        // simulate internet delay
               try await Task.sleep(for: .seconds(1))
        
        if (req.password.isEmpty && req.email.isEmpty){
            throw LoginError.fieldsAreRequired
        }
        
        if (req.email.isEmpty){
            throw LoginError.usernameEmpty
        }
        
        if (req.password.isEmpty){
            throw LoginError.passwordEmpty
        }
        if (req.password.count < 8){
            throw LoginError.PasswordMustBeAtLeast8Characters
        }
       
        
        let isUserAvailableInDb:Bool = dummyDB.contains { user in
            let isValidUser = user.email.lowercased() == req.email.lowercased()
            return isValidUser
        }
        
//        if isUserAvailableInDb {
//            return LoginResponse(token: "token1234567890") // same like guard two method
//        }else{
//            throw LoginError.invalidCredentials
//        }
//        
        
        guard isUserAvailableInDb else{
            throw LoginError.userNotFound
        }
        
        let dummyResponse = """
{
    "success": true,
    "message": "Login successful.",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NCwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzg1Mzk1Njg0LCJleHAiOjE3ODYwMDA0ODR9.tVVC4_wY6gGjuqOPtA3PjZp-dN9a9kYt9LDe3xe4vzs",
    "user": {
        "id": 4,
        "username": "Admin",
        "email": "admin@example.com",
        "role": "admin",
        "isVerified": true,
        "createdAt": "2026-07-30T06:57:54.138Z"
    }
}
"""
        do {
            let data = Data(dummyResponse.utf8)

            let response = try JSONDecoder().decode(LoginResponse.self, from: data)

            print(response.success)
            print(response.message)
            print(response.token)
            print(response.user.username)
            print(response.user.email)
            return response
        } catch  {
            print("Decoding failed:", error)
            throw LoginError.InvalidJSONFormat
        }
        
        
    
  
        
        
        
        
    }
}

