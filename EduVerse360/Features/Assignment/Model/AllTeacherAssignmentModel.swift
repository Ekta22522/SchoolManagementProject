//
//  AllAssignmentModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/09/2026.
//

struct AllTeacherAssignmentRes:Decodable{
    let success: Bool
    let message:String
    let data : [Assignment]
}
