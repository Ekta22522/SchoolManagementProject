//
//  VerifyOtpReq.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/08/2026.
//

struct VerifyOtpReq: Codable{
    let email : String
    let username : String
    let otp : String
}
