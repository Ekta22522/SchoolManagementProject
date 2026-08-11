//
//  ForgotPasswordRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//

struct ForgotPasswordRes :Codable{
    let success : Bool
    let message : String
    let otp : String
    let expiresAt : String
}
