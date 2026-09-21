//
//  StudentListViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/09/2026.
//
import Foundation
import Observation

@Observable
class StudentListViewModel{
    var students : [Student] = []
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
    
    
    private let studentListService : StudentProtocol
    init(studentlistservice : StudentProtocol = StudentServerAPI()){
        self.studentListService = studentlistservice
    }
    func ListStudent() async{
        isLoading = true
        print("Student List process is started")
        
        defer{
            isLoading = false
            print("Student List process is ended")
        }
        
        do{
            let response : StudentListRes = try await self.studentListService.studentList()
            students = response.students
            isSuccess = true
            print ("Student List Sucessfully done")
        }catch{
            errorMessage = error.localizedDescription
            print("❌ Student List failed: \(error.localizedDescription)")
        }
    }
}
