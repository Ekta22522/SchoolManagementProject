//
//  UpdateViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

import Foundation
import Observation

@Observable

class UpdateSectionViewModel{
    var classId = ""
    var sectionName = ""
    var classTeacher = ""
    var classNameError : String?
    var capacity = 0
    var section:Section?
    var isLoading = false
    var errorMessage : String?
    var isUpdateSuccess = false
    
    private let updateSectionService : SectionProtocol
    init(updatesctionservice : SectionProtocol = SectionServerAPI()){
        self.updateSectionService = updatesctionservice
    }
    
    
    
    func getSectionById (id:Int) async{
        print("Update operation is started")
        isLoading = true
        defer{
            isLoading = false
            print("Update operation is finished")
        }
        
        do{
            let response = try await self.updateSectionService.getSectionById(id: id)
            section = response.data
            classId = response.data.classId
            capacity = response.data.capacity
            print("Class Updated Successfully",isUpdateSuccess)
            
           
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func updateSection(id:Int) async {
        isLoading = true
        print("Update Section process is started")
        
        defer{
            isLoading = false
            print("Update Section Process is Finished")
        }
        
     
        do{
            let request = UpdateSectionReq(classId: classId, sectionName: sectionName, classTeacher: classTeacher, capacity: capacity)
            let response : UpdateSectionRes = try await self.updateSectionService.getUpdateSection(id:id, req: request)
            section = response.data
            
            isUpdateSuccess = true
            print("Section Updated Succesfully")
        }catch {
            errorMessage = error.localizedDescription
        }
    }
}
