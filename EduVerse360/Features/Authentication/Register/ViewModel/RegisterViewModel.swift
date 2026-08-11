//
//  RegisterViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 23/07/2026.
//

import Observation
import Foundation

@Observable
class RegisterViewModel{
    var email = ""
    var password = ""
    var fullName = ""
    var phoneNumber = ""
    var schoolName = ""
    var role: UserRole = UserRole.user
    var currentStep = 1
    var rememberMe = false
    var isLoading = false
    var token = ""
    var username = ""
    var adminSecret = ""
    var errorMessage: String?
    var emailError:String?
    var allFieldsError: String?
    var generalError:String?
    var alertMessage: String?
    var showAlert = false
    
    var isRegisterSucceess = false
    
    private let registerService : RegisterProtocol
    init(registerservice:RegisterProtocol = RegisterServerAPI()){
        self.registerService = registerservice
    }

    
    func checkAllFields(){
        if fullName.isEmpty && email.isEmpty && phoneNumber.isEmpty && schoolName.isEmpty  {
            alertMessage = "Fields are required."
            return
        }else if email.isEmpty{
            alertMessage = "Email is required"
             showAlert = true
             return
             
        }else if fullName.isEmpty{
            alertMessage = "Full Name is required"
             showAlert = true
             return
            
        }else if phoneNumber.isEmpty{
            alertMessage = "Phone Number is required"
             showAlert = true
             return
            
        }else if schoolName.isEmpty{
            alertMessage = "School Name is required"
            showAlert = true
            return
            
        }
                    
        else if  password.isEmpty{
             alertMessage = "Password is required."
                         showAlert = true
                         return
            
         }else if password.count < 8 {
             alertMessage = "Password must be 8 charcaters."
                         showAlert = true
                         return
         }else{
            alertMessage = nil
         }
    
    }
    
    func createUser() async {
        isLoading = true
        errorMessage = nil
        allFieldsError = nil
        
        defer{
            isLoading = false
        }
        do{
            let registerRequest = RegisterRequest(username: username, email:email, password: password, role: role.rawValue, adminSecret: adminSecret)
            let registerResponse = try await self.registerService.register(req: registerRequest)
            isRegisterSucceess = true
            print("Register Success:", isRegisterSucceess)
                    alertMessage = "User created successfully."
                    showAlert = true
            print("token",token)
        }catch  let error{
            self.errorMessage = error.localizedDescription

        }
    }
    
    func nextStep() {
            guard currentStep < 3 else { return }
            currentStep += 1
        }

        func previousStep() {
            guard currentStep > 1 else { return }
            currentStep -= 1
        }

    
}
