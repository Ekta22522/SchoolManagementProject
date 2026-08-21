//
//  SectionRes.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

import Foundation

struct Section: Decodable{
    let id : Int
    let classId : String
    let sectionName : String
    let classTeacher : String
    let capacity : Int
    let createdAt : String
    let updatedAt : String
    
    enum CodingKeys:String,CodingKey{
        case id
        case classId = "class_id"
        case sectionName = "section_name"
        case classTeacher = "class_teacher"
        case capacity
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
   
}
struct SectionRes:Decodable{
    let success : Bool
    let message : String
    let data : Section
    
}
