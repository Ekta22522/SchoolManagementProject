//
//  LoginModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/07/2026.
//
import Foundation


enum UserRole: String{
    case superAdmin = "superAdmin"
    case user = "user"
    case student = "student"
    case teacher = "teacher"
    case schoolAdmin = "school_admin"
}



struct UserModel: Codable,Identifiable{
    let id: Int
    let username : String
    let email : String
    let role : String
    let isVerified : Bool
    let createdAt : String
}
   


