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
    
    func getStudents() async throws -> [UserModel]
    func getStudent(by id:Int) async throws -> UserModel
    func searchStudent(searchText:String) async throws -> [UserModel]
}
