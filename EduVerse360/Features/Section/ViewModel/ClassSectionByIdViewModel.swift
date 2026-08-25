//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//
import Foundation
import Observation
@Observable
class ClassSectionByIdViewModel{
    var classSections : [Section]?
    var isLoading = true
    var errorMessage:String?
    var isSectionByIdIsSuccess = false
    
    private let sectionByIdService : SectionProtocol
    init(sectionbyidservice : SectionProtocol = SectionServerAPI()){
        self.sectionByIdService = sectionbyidservice
    }
    
    func classSection(id:String) async{
        print("Section By ID process is started")
        isLoading = true
        
        defer{
            isLoading = false
            print("Process is Finished")
        }
        do{
            let response : ClassSectionByIdRes = try await self.sectionByIdService.getClassSectionById(id: id)
            isSectionByIdIsSuccess = true
            classSections = response.data
            print("Class Section by ID fetched Successfully")
            
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
