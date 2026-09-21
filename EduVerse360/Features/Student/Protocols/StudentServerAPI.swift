//
//  StudentServerAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/09/2026.
//

class StudentServerAPI : StudentProtocol{
    func studentList() async throws -> StudentListRes {
        do{
            let studentListRes : StudentListRes = try await APIClient.shared.request(APIEndpoint.students)
            return studentListRes
            
        }catch let error{
            throw error
            
        }
    }
    
    func createStudent(req:CreateStudentReq) async throws -> CreateStudentRes {
        do{
            let response : CreateStudentRes = try await APIClient.shared.request(APIEndpoint.createStudent, body: req)
            return response
        }catch let error{
            throw error
        }
    }
    
    func getStudentById(id:Int) async throws -> StudentByIdRes {
        do{
            let response : StudentByIdRes = try await APIClient.shared.request(APIEndpoint.studentById(id: id))
            return response
        }catch let error{
            throw error
        }
        
    }
    
    func updateStudent(req:UpdateStudentReq,id: Int) async throws -> UpdateStudentRes{
        do{
            let response : UpdateStudentRes = try await APIClient.shared.request(APIEndpoint.updateStudent(id: id), body: req)
            return response
        }catch let error{
          throw error
        }
    }
}
