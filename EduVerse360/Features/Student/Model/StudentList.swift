//
//  StudentList.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/09/2026.
//

struct Student: Codable, Hashable{
    let id : Int
    let userId: Int
    let userName : String?
    let email : String?
    let role : String?
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
    let createdAt : String
    let updatedAt: String
    
    enum CodingKeys : String, CodingKey{
        case id
        case userId
        case userName = "username"
        case email 
        case role
        case admissionNumber 
        case enrollmentYear
        case major
        case dateOfBirth
        case gender
        case address
        case guardianName
        case guardianPhone
        case status
        case isAlumni
        case createdAt
        case updatedAt
        
    }
    
    
}
struct StudentListRes : Decodable{
    let success : Bool
    let students : [Student]
}
