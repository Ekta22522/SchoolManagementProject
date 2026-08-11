//
//  VerifyRegisterationRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

import Foundation

struct VerifyRegisterationRes : Codable{
    let success : Bool
    let message : String
    let token : String
    let user : UserModel
}
