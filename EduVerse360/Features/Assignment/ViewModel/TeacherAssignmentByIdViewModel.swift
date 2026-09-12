//
//  TeacherAssignmentByIdViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable
class TeacherAssignmentByIdViewModel{
    var assignment : Assignment?
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
    
    private var teacherAssignmentByIdService : AssignmentProtocol
    
    init(teacherassignmentbyidservice : AssignmentProtocol = AssignmentServerAPI()){
        self.teacherAssignmentByIdService = teacherassignmentbyidservice
    }
    
    func TeacherAssignmentById(id : Int) async{
       isLoading = true
        print("Process is Started")
        defer{
            isLoading = false
            print("Process is Ended")
        }
        do{
            let response : TeacherAssignimentByIdRes = try await teacherAssignmentByIdService.getTeacherAssignmentById(id: id)
            assignment = response.data
            isSuccess = true 
        }catch{
            errorMessage = error.localizedDescription
        }
        
       
    }
}
