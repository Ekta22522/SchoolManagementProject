//
//  TeacherRepository.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import Foundation
enum TeacherError: LocalizedError{
    case TeacherNotFound
}
protocol TeacherProtocol{
    func getTeachers() async throws -> [UserModel]
    func getTeachers(by id:Int) async throws -> UserModel
    func searchTeachers(searchText: String) async throws -> [UserModel]
}
