//
//  UpdateStudent.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

struct UpdateStudentReq:Encodable{
    let userId: Int
    let admissionNumber: String
    let enrollmentYear: Int
    let major: String
    let dateOfBirth: String
    let gender: String
    let address: String
    let guardianName: String
    let guardianPhone: String
    let status: String
    let isAlumni: Bool
}


struct UpdateStudentRes : Decodable{
    let success : Bool
    let message : String
    let student : Student
}
