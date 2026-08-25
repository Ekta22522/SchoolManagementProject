//
//  UpdateSection.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

struct UpdateSectionReq:Encodable{
    let classId : String
    let sectionName : String
    let classTeacher : String
    let capacity : Int
    
    enum CodingKeys:String,CodingKey{
        case classId = "class_id"
        case sectionName = "section_name"
        case classTeacher = "class_teacher"
        case capacity
    }
}
