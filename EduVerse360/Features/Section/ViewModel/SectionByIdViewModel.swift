//
//  SectionByViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

import Foundation
import Observation
@Observable

class SectionByIdViewModel{
    var section : Section?
     var isLoading = false
    var errorMessage : String?
    var isFetchedSuccesfully = false
    
    private let sectionByIdService : SectionProtocol
    init(sectionbyidservice : SectionProtocol = SectionServerAPI()){
        self.sectionByIdService = sectionbyidservice
    }
    
    func section(id:Int) async {
        print("Section By ID  processs is started")
        isLoading = true
        
        defer{
            isLoading = false
            print("Section BY ID process is finished")
        }
        
        do{
            let response : SectionById = try await self.sectionByIdService.getSectionById(id: id)
           isFetchedSuccesfully = true
            section = response.data
        print("Section by ID fetched Successfully")
            
        }catch {
            errorMessage = error.localizedDescription
        }
        
    }
}
