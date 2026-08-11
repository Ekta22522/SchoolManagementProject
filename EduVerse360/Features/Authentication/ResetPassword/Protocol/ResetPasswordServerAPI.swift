//
//  ResetPasswordImp.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/08/2026.
//
import Foundation

class ResetPasswordServerAPI : ResetPassowrdProtocol{
    func resetPassword(req: ResetPasswordReq) async throws -> ResetPasswordRes {
        do{
            let resetPasswordRes : ResetPasswordRes = try await APIClient.shared.request(APIEndpoint.resetPassword, body: req)
            return resetPasswordRes
            
        }catch let error{
           throw error
        }
    }
}
