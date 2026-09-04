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
    case classes
    case allClasses
    case classByID(id: String)
    case updateClass(id: String)
    case deleteClass(id:String)
    case createSection(id:String)
    case allSection
    case classSection(id:String)
    case sectionById(id:Int)
    case updateSection(id:Int)
    case deleteSection (id: Int)
    case createOnlineClass
    case readAllOnlineClass
    case onlineClassById(id:Int)
    case updateOnlineClass(id:Int)
    case deleteOnlineClass(id:Int)
    case profile
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
          
        //authentication part
            
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
        
        //Classes part
            
        case.classes:
            return "api/classes"
        case.allClasses:
            return "api/classes"
        case.classByID(let id):
            return "api/classes/\(id)"
        case.updateClass(let id):
            return "api/classes/\(id)"
        case.deleteClass(let id):
            return "api/classes/\(id)"
            
        //Section part
            
        case.createSection:
            return "api/sections"
         
        case.allSection:
            return "api/sections"
        
        case.classSection(let id):
            return "api/classes/\(id)/sections"
            
        case.sectionById(let id):
            return "api/sections/\(id)"
            
        case.updateSection(let id):
            return "api/sections/\(id)"
            
        case.deleteSection(let id):
            return "api/sections/\(id)"
         
            
            //Online class
            
        case.createOnlineClass:
            return "api/online-classes"
        case.students:
            return ""
        case.readAllOnlineClass:
            return"api/online-classes"
        case.onlineClassById(let id):
            return "api/online-classes/\(id)"
        case.updateOnlineClass(let id):
            return "api/online-classes/\(id)"
        case.deleteOnlineClass(let id):
            return "api/online-classes/\(id)"
        case.teachers:
            return ""
        case.profile:
            return "api/users/me"
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
            .classes,
            .resetPassword,
            .createSection,
            .createOnlineClass:
            return .POST
            
        case.students,
            .profile,
            .teachers,
            .student,
            .dashboard,
            .teacher,
            .allClasses,
            .classByID,
            .allSection,
            .classSection,
            .sectionById,
            .readAllOnlineClass,
            .onlineClassById:
            return .GET
            
        case.updateClass,
            .updateSection,
            .updateOnlineClass:
            return.PUT
            
        case.deleteClass,
            .deleteSection,
            .deleteOnlineClass:
            return.DELETE
            
        
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
