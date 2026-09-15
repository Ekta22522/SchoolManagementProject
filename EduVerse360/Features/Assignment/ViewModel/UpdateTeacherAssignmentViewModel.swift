//
//  UpdateTeacherAssignmentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 15/09/2026.
//

import Foundation
import Observation

 @Observable
class UpdateTeacherAssignmentViewModel{
    
    var isLoading = false
    var isSuccess = false
    var assignment : Assignment?

    var erroMessage : String?
    
    private var updateTeacherAssignmentService : AssignmentProtocol
    init(updateteacherassignmentservice:AssignmentProtocol = AssignmentServerAPI()){
        self.updateTeacherAssignmentService = updateteacherassignmentservice
    }
    
    func updateTeacherAssignment(id:Int)async {
        isLoading = true
        print("Update Teacher Assignment is started")
        defer{
            isLoading = false
            print("Update Teacher Assignment is ended")
        }
        do{
            let response : UpdateAssignmentRes = try await self.updateTeacherAssignmentService.updateTeacherAssignment(id: id)
            assignment = response.data
            isSuccess = true
            print(" Teacher Assignment Successfully Updated")
        }catch{
            erroMessage = error.localizedDescription
        }
        
       
    }
}
