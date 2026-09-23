//
//  StudentByIdViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import Foundation
import Observation

@Observable
class StudentByIdViewModel{
    var student : Student?
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
    
    private var studentByIdService : StudentProtocol
    
    init(studentbyidservice : StudentProtocol = StudentServerAPI()){
        self.studentByIdService = studentbyidservice
    }
    
    func studentById(id:Int)async{
        isLoading = true
        print("Student by id process is started")
        defer{
            isLoading = false
            print("Student by id process is ended")
        }
        do{
            let response : StudentByIdRes = try await self.studentByIdService.getStudentById(id: id)
            student = response.student
            isSuccess = true
            print("Student By ID fetched Succesffully")
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
