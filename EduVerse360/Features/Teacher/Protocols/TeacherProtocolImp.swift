//
//  TeacherRepositoryImp.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//
import Foundation

class TeacherMockAPI : TeacherProtocol{
    
    func searchTeachers(searchText: String) async throws -> [UserModel] {
        
        let teachers = dummyDB.filter{ user in
            return user.role == "teacher"
        }
        
        if searchText.isEmpty {
            return teachers
        }
        
//        let filterTeachers = teachers.filter{ teacher in
//            teacher.firstName.lowercased().contains(searchText.lowercased()) || teacher.lastName.lowercased().contains(searchText.lowercased())
//        }
//        
//        return filterTeachers
        return []
//
    }
    
    func getTeachers() async throws -> [UserModel]{
        return dummyDB.filter{ user in
            return user.role == "teacher"
        }
    }
    
    func getTeachers(by id:Int) async throws -> UserModel{
        let teacherById = dummyDB.filter{user in
            return user.role == "teacher" && user.id == id
        }.first
        guard let teacherById else{
            throw TeacherError.TeacherNotFound
        }
        return  teacherById
    }
    
    
    
}
