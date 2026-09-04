//
//  ClsssRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//
import Foundation


struct ClassRes : Decodable {
    let success : Bool
    let message : String
    let data : Class
}


struct Class: Decodable, Identifiable{
    
    let id: String
    let className: String
    let description: String
    let createdAt: String
    let updatedAt: String?
    let sectionCount : Int?
    let totalCapacity : Int?
    let sections : [Section]?

    enum CodingKeys: String, CodingKey {
        case id
        case className = "class_name"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sectionCount = "section_count"
        case totalCapacity = "total_capacity"
        case sections
    }
}
