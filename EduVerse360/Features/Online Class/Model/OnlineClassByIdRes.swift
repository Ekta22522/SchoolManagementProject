//
//  OnlineClassByIdRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/09/2026.
//

struct OnlineClassByIdRes:Decodable{
    let success : Bool
    let message : String
    let data : OnlineClass
}
