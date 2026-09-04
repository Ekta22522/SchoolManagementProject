//
//  SectionById.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//

struct ClassSectionRes:Decodable{
    let success: Bool
    let classroom : Class
    let sectionCount : Int
    let section : [Section]
    
    enum CodingKeys: String, CodingKey{
        case success
        case classroom = "class"
        case sectionCount = "section_count"
        case section = "data"
    }
}
