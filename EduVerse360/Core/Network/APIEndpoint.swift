//
//  APIEndpoint.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/08/2026.
//
import Foundation

enum APIEndpoint {

    case login
    case register
    case verifyRegisteration
    case forgotPassword
    case verifyOtp
    case resetPassword
    case students
    case teachers
    case student(id:Int)
    case teacher(id:Int)
    case uploadProfileImage(id:Int)
    case dashboard

}

extension APIEndpoint{
    var path : String{
        
        switch self{
            
        case.login:
        return "/api/users/login"
        
        case.register:
            return "/api/users/register"
        case.verifyRegisteration:
            return "/api/users/verify-registration-otp"
        case.forgotPassword:
            return "api/users/forgot-password"
        case.verifyOtp:
            return "api/users/verify-otp"
        case.resetPassword:
            return "api/users/reset-password"
        
        case.students:
            return ""
            
        case.teachers:
            return ""
            
        case.student(let id):
            return ""
          
        case.teacher(let id):
            return ""
            
        case.uploadProfileImage(let id):
            return ""
            
        case .dashboard:
            return ""
        }
    }
}


extension APIEndpoint{
    var method:HTTPMethod{
        
        switch self{
        case.login,
            .register,
            .verifyRegisteration,
            .forgotPassword,
            .verifyOtp,
            .resetPassword:
            return .POST
            
        case.students,
            .teachers,
            .student,
            .dashboard,
            .teacher:
            return .GET
        
        case.uploadProfileImage:
            return .POST
        }
    }
}


extension APIEndpoint{
    var url : URL{
        
        AppConfiguration.environemnt
            .baseURL
            .appending(path:path)
    }
}
