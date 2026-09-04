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
    var role: UserRole = UserRole.user
    var rememberMe = false
    var isLoading = false
    var token = ""
    var username = ""
    var adminSecret = "admin-secret-2026"
    var registerError: String?
    var usernameError:String?
    var fieldError:String?
    var emailError:String?
    var passwordError:String?
    var alertMessage: String?
    var showAlert = false

    var isRegisterSucceess = false
    
    private let registerService : RegisterProtocol
    init(registerservice:RegisterProtocol = RegisterServerAPI()){
        self.registerService = registerservice
    }

    
    func checkAllFields() -> Bool{
        emailError = nil
        fieldError = nil
        passwordError = nil
        usernameError = nil
        
        if username.isEmpty && email.isEmpty && password.isEmpty {
        fieldError = "Fields are required."
            return false
        }else if email.isEmpty{
           emailError = "Email is required"
            return false
        }else if username.isEmpty{
            usernameError = "Full Name is required"
            
            return false
            
        }else if  password.isEmpty{
             passwordError = "Password is required."
            return false
            
         }else if password.count < 8 {
            passwordError = "Password must be 8 charcaters."
             return false
         }else{
             return true
         }
    
    }
    
  func createUser() async {
        isLoading = true

        emailError = nil
        usernameError = nil
        fieldError = nil
        passwordError = nil
        registerError = nil

        defer {
           isLoading = false
        }

        do {
            let registerRequest = RegisterRequest(
                username: username,
                email: email,
                password: password,
                role: role.rawValue,
                adminSecret: adminSecret
            )

            let registerResponse = try await registerService.register(
                req: registerRequest
            )

            // 201 = SUCCESS
            isRegisterSucceess = true

            print("Register Success:", isRegisterSucceess)
            alertMessage = "User created successfully."
                               showAlert = true
            print("OTP:", registerResponse.otp)

        } catch let error as NetworkError {

            switch error {

            case .serverError(let statusCode):

                print("Server status code:", statusCode)

                if statusCode == 400 {
                    registerError = "Username, email, and password are required"

                }else if statusCode == 422 {
                    registerError = "Invalid role specified."
                }
                else if statusCode == 409 {
                    registerError = "Email already registered and verified."

                } else if statusCode == 403 {
                    registerError = "Only standard users can self-register without admin approval."

                } else if statusCode == 500 {
                    registerError = "Registration failed."

                } else {
                    registerError = "Something went wrong. Please try again."
                }

            case .noInternet:
                registerError = "No internet connection."

            default:
                registerError = "Something went wrong. Please try again."
            }

        } catch {
            registerError = "Something went wrong. Please try again."
        }
    }
    }
    
  

    

