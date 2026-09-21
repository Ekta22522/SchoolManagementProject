//
//  StudentRepository.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import Foundation

enum StudentError : LocalizedError{
    case studentNotFound

}

protocol StudentProtocol {
    
    func studentList()async throws -> StudentListRes
    func createStudent(req:CreateStudentReq) async throws -> CreateStudentRes
    func getStudentById(id:Int)async throws -> StudentByIdRes
    func updateStudent(req:UpdateStudentReq,id:Int)async throws -> UpdateStudentRes
   
    
    
}
