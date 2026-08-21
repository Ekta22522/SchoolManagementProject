//
//  SectionViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

import Foundation
import Observation
@Observable

class SectionViewModel{
    var classId  = ""
    var sectionName = ""
    var classTeacher = ""
    var capacity = ""
    var sectionData : Section?
    var isLoading = false
    var errorMessage : String?
    var isSectionSuccess = false
    var error : String?
    
    private let sectionService : SectionProtocol
    init(sectionservice:SectionProtocol = SectionServerAPI()){
        self.sectionService = sectionservice
    }
    
    
    func getclassId(Id:String){
        classId = Id
    }
    
    func postSection(id:String)async{
       isLoading = true
        print("Creating section process is started")
    
        defer{
            isLoading = false
            print("Creating section process is finished")
        }
        do{
            let request = SectionReq(classId: classId , sectionName: sectionName, classTeacher: classTeacher, capacity: capacity)
            let response : SectionRes = try await self.sectionService.createSection(req: request,id:id)
            sectionData = response.data
            isSectionSuccess = true
            print(response.data.id,sectionName,"Section Created Succesffully")
            
        }catch{
            errorMessage = error.localizedDescription
        }
        
    }
}
