//
//  SectionReq.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

struct SectionReq:Encodable{
    
    let classId : String
    let sectionName : String
    let classTeacher : String
    let capacity : String
    
    
    enum CodingKeys: String, CodingKey {
        case classId = "class_id"
        case sectionName = "section_name"
        case classTeacher = "class_teacher"
        case capacity
    }

}
