//
//  ListSectionViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/08/2026.
//
import Foundation
import Observation
@Observable

class ListSectionViewModel{
    var listSection : [Section]?
    var isLoading = false
    var errorMessage : String?
    var isAllSecSuccess = false
    
    private let listSectionService : SectionProtocol
    init(listsectionservice:SectionProtocol = SectionServerAPI()){
        self.listSectionService = listsectionservice
    }
    
    func getAllSection()async{
        print("Listing section process is started")
        isLoading = true
        defer{
            isLoading = false
            print("Listing section process is finished")
        }
        do{
            let response : ListSectionRes = try await self.listSectionService.listSection()
            listSection = response.data
            isAllSecSuccess = true
            print("All section Fetched Successfully")
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
}
