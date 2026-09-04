//
//  Untitled.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//
import Foundation
import Observation
@Observable
class ClassSectionViewModel{
    var classRoom : Class?
    var section : [Section]?
    var isLoading = true
    var errorMessage:String?
    var isClassSectionSuccess = false
    
    private let classSectionService : SectionProtocol
    init(classsectionservice : SectionProtocol = SectionServerAPI()){
        self.classSectionService  = classsectionservice
    }
    
    func classSection(id:String) async{
        print("Section By ID process is started")
        isLoading = true
        
        defer{
            isLoading = false
            print("Process is Finished")
        }
        do{
            let response : ClassSectionRes = try await self.classSectionService.getClassSection(id: id)
            isClassSectionSuccess = true
            classRoom = response.classroom
            section = response.section
            print("Class Section by ID fetched Successfully")
            
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
