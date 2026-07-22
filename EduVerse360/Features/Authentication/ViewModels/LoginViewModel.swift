//
//  LoginViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//
import Foundation
import Observation


@Observable

class LoginViewModel{

    var password = ""
    var email = ""
    var rememberMe = false
    var isLoading = false
    var token = ""
    var errorMessage: String?
    var emailError:String?
    var allFieldsError: String?
    var userNotFound: String?
    var passwordError:String?
    var generalError:String?
    var alertMessage: String?
    var showAlert = false
    
    var isLoginSucceess = false
    
  
    
    private let loginService : LoginAPIProtocol
    init (loginservice:LoginAPIProtocol = LoginMockAPI()){
        self.loginService = loginservice
    }
    
    
    func updateUsername(sess: UserSession){
        sess.username = email
    }
    
    func saveToken(sess:UserSession){
        sess.token = token
    }
    
    
    
    func checkAllFields(){
        if email.isEmpty && password.isEmpty {
            alertMessage = "Fields are required."
            return
        }else if email.isEmpty{
            alertMessage = "Username is required"
             showAlert = true
             return
             
         }else if  password.isEmpty{
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
    
//    func validateEmail(){
//        if email.isEmpty{
//           alertMessage = "Username is required"
//            showAlert = true
//            return
//            
//        }else{
//            emailError = nil
//        }
//        
//    }
//    
//    func validatePassword(){
//        
//        if password.isEmpty{
//            alertMessage = "Password is required."
//                        showAlert = true
//                        return 
//        }else if password.count < 8 {
//            alertMessage = "Password must be 8 charcaters."
//                        showAlert = true
//                        return
//        }else{
//            passwordError = nil
//        }
//        
//    }
    
    
    
    
    
    func loginUser() async {
        print("Login User started")
        isLoading = true
        errorMessage = nil
        allFieldsError = nil
    
      

         
        defer{isLoading = false}
        
        do{
            let loginRequest = LoginRequest(username:email, password: password)
            let loginResponse = try await self.loginService.login(req: loginRequest)
            UserDefaultsManager.shared.save(data: loginResponse.token, key:.token)
            isLoginSucceess = true
            print("Login Success:", isLoginSucceess)
            print("token:",loginResponse.token)
       
    
        } catch  let error as LoginError{
            switch error {
                
            case .fieldsAreRequired:
                alertMessage = "Fields are required."
                showAlert = true

            case .usernameEmpty:
                alertMessage = "Username is required."
                showAlert = true

            case .passwordEmpty:
                alertMessage = "Password is required."
                showAlert = true

            case .PasswordMustBeAtLeast8Characters:
                alertMessage = "Password must be at least 8 characters."
                showAlert = true

            case .invalidCredentials:
                alertMessage = "Invalid username or password."
                showAlert = true

            case .userNotFound:
                alertMessage = "User not found."
                showAlert = true
            
            }
            
        }
        catch{
            self.errorMessage = "Something went wrong. Please try again."
            }
        }

    }
    


