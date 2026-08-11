//
//  VerifyOtpViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/08/2026.
//

import Foundation
import Observation

@Observable
class VerifyOtpViewModel{
    var otp = ""
    var email = ""
    var username = ""
    var isLoading = false
    var  isVerifyOtpSucess = false
    var errorMessage:String?
    var emailError :String?
    var showAlert = false
    var alertMessage:String?
  
    
    private let verifyOtpService: ForgotPasswordProtocol
    
    init(verifyotpservice:ForgotPasswordProtocol = ForgotPasswordServerAPI()){
        self.verifyOtpService = verifyotpservice
    }
    
    func verifyOtp()async{
        isLoading = true
        errorMessage = nil
        print("OTP Verification Started")
        
        defer{
            isLoading = false
            print("Otp Verification finished")
        }
        
        do{
            let verifyOtpReq = VerifyOtpReq(email: email, username: username, otp: otp)
                    print("2️⃣ Email:", email)
                    print("Username", username)
                    print("3️⃣ OTP:", otp)
                    print("4️⃣ Sending request...")
            let verifyOtpRes = try await self.verifyOtpService.verifyOtp(req:verifyOtpReq)
            
            isVerifyOtpSucess = true
            print("OIP Verification is Sucessfull", isVerifyOtpSucess)
            alertMessage = "OTP verified Successfully"
            showAlert = true
           
        }catch let error{
            self.errorMessage = error.localizedDescription
            
        }
    }
}

