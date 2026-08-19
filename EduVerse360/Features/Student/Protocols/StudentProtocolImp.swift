//
//  StudentRepositoryImp.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//


class StudentMockAPI: StudentProtocol{
    
    func searchStudent(searchText:String) async throws ->[UserModel]{
        let students = dummyDB.filter { user in
            return user.role == "student"
        }
        
        if students.isEmpty{
            return students
        }
        
//        let filterStudents = students.filter{ student in
//            student.firstName.lowercased().contains(searchText.lowercased()) || student.lastName.lowercased().contains(searchText.lowercased())
//        }
//        return filterStudents
        return []
        
    }
    
    func getStudents() async throws -> [UserModel]{
        return dummyDB.filter{ user in
            return user.role == "student"
        }
    }
    
    func getStudent(by id:Int) async throws -> UserModel{
        
        
        let students = dummyDB.filter{user in
            return user.role == "student" && user.id == id
        }
        
        let studentById = students.last
        
        guard let studentById else{
            throw StudentError.studentNotFound
        }
        return  studentById
    }
    
    
    
}
