//
//  RegisterResponse.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

struct RegisterResponse : Codable{
    let success : Bool
    let message : String
    let user : UserModel
    let otp : String
    let expiresAt : String
}
