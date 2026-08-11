//
//  LoginResponse.swift
//  EduVerse360
//
//  Created by Ekta Rai on 30/07/2026.
//


struct LoginResponse : Codable{
    let success: Bool
    let message: String
    let token : String
    let user : UserModel
}
