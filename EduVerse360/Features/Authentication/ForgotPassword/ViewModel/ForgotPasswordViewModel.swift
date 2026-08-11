//
//  ForgotPasswordViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//
import Foundation
import Observation

@Observable
class ForgotPasswordViewModel{
    var email = ""
    var errorMessage: String?
    var emailError:String?
    var isLoading = false
    var isForgotPasswordSuccess = false
    
    private let forgotPasswordService : ForgotPasswordProtocol
    init(
    forgotpasswordservice: ForgotPasswordProtocol = ForgotPasswordServerAPI()){
        self.forgotPasswordService = forgotpasswordservice
    }
    
    func forgotPassword () async {
        print("forgot password is started")
        isLoading = true
        errorMessage = nil
        defer{
            isLoading = false
            print("forgot password disclose")
        }
        
        do {
            let forgotPasswordReq = ForgotPasswordReq(email: email)
            let forgotPasswordRes = try await self.forgotPasswordService.forgotPassword(req: forgotPasswordReq)
            isForgotPasswordSuccess = true
            print("Forgot Password Successfully done with OTP \(forgotPasswordRes.otp)")
        }catch let error{
            self.errorMessage = error.localizedDescription
        }
        
    }
    
    
}
