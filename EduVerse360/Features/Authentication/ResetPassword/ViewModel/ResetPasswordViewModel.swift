//
//  ResetPasswordViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//
import Foundation
import Observation

@Observable
class ResetPasswordViewModel{
    var email = ""
    var password = ""
    var confirmPassword = ""
    var emailError:String?
    var erroMessage : String?
    var isLoading = false
    var isResetPasswordSucess = false
    
    private let resetPasswordService : ResetPassowrdProtocol
    
    init(resetpasswordservice:ResetPassowrdProtocol = ResetPasswordServerAPI()){
        self.resetPasswordService = resetpasswordservice
    }
    
    func resetPassword()async{
       isLoading = true
    print("Reset Password process is started")
        defer{
            isLoading = false
        }
        do{
            let resetPasswordReq = ResetPasswordReq(email:email,password:password)
            let resetPasswordRes = try await self.resetPasswordService.resetPassword(req: resetPasswordReq)
            isResetPasswordSucess = true
            print("Password reset Sucessfully",isResetPasswordSucess)
        }catch let error{
            erroMessage.self = error.localizedDescription
        }
    }
}
