//
//  VerifyRegistrationViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 08/08/2026.
//

import Foundation
import Observation

@Observable
class VerifyRegistrationViewModel{
    var otp = ""
    var email = ""
    var isLoading = false
    var isVerificationSucess = false
    var errorMessage:String?
    var showAlert = false
    var alertMessage:String?
  
    
    private let verifyRegisterationService: RegisterProtocol
    
    init(verifyregisterationrservice:RegisterProtocol = RegisterServerAPI()){
        self.verifyRegisterationService = verifyregisterationrservice
    }
    
    func verifyRegister()async{
        isLoading = true
        errorMessage = nil
        print("1️⃣ verifyRegister() started")
        
        defer{
            isLoading = false
            print("6️⃣ verifyRegister() finished")
        }
        
        do{
            let verifyRegisterationReq = VerifyRegisterationReq(email: email, otp: otp)
                    print("2️⃣ Email:", email)
                    print("3️⃣ OTP:", otp)
                    print("4️⃣ Sending request...")
            let verifyRegisterRes = try await self.verifyRegisterationService.verifyRegistration(req:verifyRegisterationReq)
            
            isVerificationSucess = true
            print("Verification Sucessfull",isVerificationSucess)
            alertMessage = "OTP verified Successfully"
            showAlert = true
           
        }catch let error{
            self.errorMessage = error.localizedDescription
            
        }
    }
}
