//
//  RegisterServerAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

import Foundation
struct RegisterServerAPI : RegisterProtocol{
    
    func register(req: RegisterRequest)  async throws -> RegisterResponse{
        
        do {
            let registerResponse: RegisterResponse = try await APIClient.shared.request(APIEndpoint.register, body: req)
            return registerResponse
        }
        catch let error {
            throw error
        }
    }
    
    func verifyRegistration (req:VerifyRegisterationReq) async throws -> VerifyRegisterationRes{
        do{
            let verifyRegisterationResponse : VerifyRegisterationRes = try await APIClient.shared.request(APIEndpoint.verifyRegisteration, body:req)
            
            return verifyRegisterationResponse
        } catch let error {
            throw error
        }
        
    }
    
}
