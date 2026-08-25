//
//  DeleteSectionViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 25/08/2026.
//

import Foundation
import Observation
@Observable
class DeleteSectionViewModel{
    var sectionName = ""
    var isLoading = false
    var errorMessage : String?
    var isDeleteSuccess = false
    var section : Section?
    
    private let deleteSectionService : SectionProtocol
    init(deletesectionservice:SectionProtocol = SectionServerAPI()){
        self.deleteSectionService = deletesectionservice
    }
    
    func getSectionById (id:Int) async{
        print("Update operation is started")
        isLoading = true
        defer{
            isLoading = false
            print("Update operation is finished")
        }
        
        do{
            let response = try await self.deleteSectionService .getSectionById(id: id)
            section = response.data
            sectionName = response.data.sectionName
            print("Class Updated Successfully",isDeleteSuccess)
            
           
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteSection(id: Int) async{
       isLoading = true
        print("Deleteing process is started")
        
        defer{
            isLoading = false
            print("Deleteing process is ended")
        }
        
            do {
                let response : DeleteSecRes = try await self.deleteSectionService.getDeleteSec(id: id)
               isDeleteSuccess = true
                
            }catch{
                errorMessage = error.localizedDescription
            }
        
    }
    
    
}
