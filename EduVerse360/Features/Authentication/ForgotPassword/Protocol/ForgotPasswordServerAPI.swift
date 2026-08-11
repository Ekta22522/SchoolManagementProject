//
//  ForgotPasswordServerAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//
import Foundation
class ForgotPasswordServerAPI : ForgotPasswordProtocol{
    
    func forgotPassword(req: ForgotPasswordReq) async throws -> ForgotPasswordRes {
       
        do{
            let response : ForgotPasswordRes = try await APIClient.shared.request(APIEndpoint.forgotPassword,body : req)
            
            return response
            
        }catch let error {
            throw error
        }
      
    }
    
    func verifyOtp(req: VerifyOtpReq) async throws -> VerifyOtpRes {
        do{
            let response : VerifyOtpRes = try await APIClient.shared.request(APIEndpoint.verifyOtp, body: req)
            return response
        }catch{
            throw error
        }
    }
}
