//
//  DeleteTeacherAssignmentViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 16/09/2026.
//


import Foundation
import Observation

@Observable
class DeleteTeacherAssignmentViewModel{
   
    var isLoading = false
    var isSuccess = false
    var errorMessage : String?
    
    private var deleteTeacherAssignmentServcie : AssignmentProtocol
    
    init(deleteteacherassignmentservice : AssignmentProtocol = AssignmentServerAPI()){
        self.deleteTeacherAssignmentServcie = deleteteacherassignmentservice
    }
    
    func deleteTeacherAssignment(id:Int) async {
       isLoading = true
    print("Delete Teacher Assignment is started")
        
        defer{
            isLoading = false
            print("Delete Teacher Assignment is ended")
        }
        
        do{
            let response : DeleteTeacherAssignmentRes = try await self.deleteTeacherAssignmentServcie.deleteTeacherAssignment(id: id)
            isSuccess = true
            print("Successfully deleted")
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
