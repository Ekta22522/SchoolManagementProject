//
//  UpdateSectionRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

struct UpdateSectionRes:Decodable{
    let success: Bool
    let message : String
    let data : Section?
}
