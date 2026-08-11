//
//  RegisterRequest.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

import Foundation

struct RegisterRequest : Encodable{
    let username : String
    let email : String
    let password : String
    let role : String
    let adminSecret : String
}
