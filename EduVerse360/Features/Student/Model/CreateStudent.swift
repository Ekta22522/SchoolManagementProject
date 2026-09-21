//
//  CreateStudent.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

struct CreateStudentReq : Codable{
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
    let createdAt : String?
    let updatedAt: String?
    
//    enum CodingKeys : String, CodingKey{
//        case userId = "user_id"
//        case admissionNumber = "admission_number"
//        case enrollmentYear = "enrollment_year"
//        case major
//        case dateOfBirth = "date_of_birth"
//        case gender
//        case address
//        case guardianName = "guardian_name"
//        case guardianPhone = "guardian_phone"
//        case status
//        case isAlumni = "is_alumni"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        
//    }
    
}

struct CreateStudentRes:Decodable{
    let success : Bool
    let message : String
    let student : Student
}
