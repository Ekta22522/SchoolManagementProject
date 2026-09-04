//
//  LoginViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//
import Foundation
import Observation

@MainActor
@Observable

class LoginViewModel{
    
    var password: String = ""
    var email: String = ""
    var rememberMe: Bool = UserDefaultsManager.shared.read(key: .rememberMe)
    var isLoading = false
    var token = ""
    var emailError: String?
    var passwordError: String?
    var loginError: String?
    
    
    var isLoginSucceess = false
    
    var userModel: UserModel?
    
    private let loginService : LoginProtocol
    
    init (loginservice:LoginProtocol = LoginMockAPI()){
        self.loginService = loginservice
        if rememberMe {
            email = UserDefaultsManager.shared.read(key: .email) ?? ""
        }
    }
    
    
    func toggleRememberMe(){
        rememberMe.toggle()
        UserDefaultsManager.shared.save(data: rememberMe, key:.rememberMe)
    }
    
    
    
    func updateUserModel(sess: UserSession){
        sess.updateUserModel(model: userModel)
    }
    
    
    func updateUsername(sess: UserSession){
        sess.username = email
    }
    
    func saveToken(sess:UserSession){
        sess.token = token
    }
    
    
    
    func checkAllFields(){
        emailError = nil
        passwordError = nil
        loginError = nil
        
        if email.isEmpty && password.isEmpty {
            emailError = "Fields are required."
            return
        }else if email.isEmpty{
            emailError = "Username is required"
            return
            
        }else if  password.isEmpty{
            passwordError = "Password is required."
            
            return
        }else if password.count < 8 {
            passwordError = "Password must be 8 charcaters."
            
            return
        }else{
            
        }
        
    }
    
    
    
    
    
    func loginUser() async {
        print("Login User started")
        isLoading = true
        emailError = nil
        passwordError = nil
        loginError = nil
        
        
        
        defer{isLoading = false}
        
        do{
            let loginRequest = LoginRequest(email:email, password: password)
            let loginResponse = try await self.loginService.login(req: loginRequest)
            UserDefaultsManager.shared.save(data: loginResponse.token, key:.token)
            isLoginSucceess = true
            userModel = loginResponse.user
            
            if rememberMe {
                UserDefaultsManager.shared.save(data: email, key: .email)
            }else{
                UserDefaultsManager.shared.remove(key: .email)
            }
            print("Login Success:", isLoginSucceess)
            print("token:",loginResponse.token)
            
            
        } catch  let error as NetworkError {
            switch error {

                case .serverError(let statusCode):
                    print("Server status code:", statusCode)

                    if statusCode == 400 {
                        loginError = "Invalid request."
                    } else if statusCode == 401 {
                        loginError = "Invalid email or password."
                    } else if statusCode == 404 {
                        loginError = "User not found."
                    } else if statusCode == 500 {
                        loginError = "Server error. Please try again later."
                    }

                case .unauthorized:
                    loginError = "Unauthorized."

                case .noInternet:
                    loginError = "No internet connection."

                default:
                    loginError = "Something went wrong. Please try again."
                }

            } catch {
                loginError = "Something went wrong. Please try again."
            }
        }
        
    }
    


