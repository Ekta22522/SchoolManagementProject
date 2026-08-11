//
//  VerifyRegisteration.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

import Foundation

struct VerifyRegisterationReq : Encodable{
    let email : String
    let otp : String
}

