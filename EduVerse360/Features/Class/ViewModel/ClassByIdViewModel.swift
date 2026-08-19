//
//  ClassByIDViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import Foundation
import Observation

@Observable

class ClassByIdViewModel {
    
    var classroom: Class?
    var isLoading = false
    var isFetchingClassById = false
    var errorMessage: String?
    
    private let classByIdService: ClassProtocol
    
    init(classbyidservice: ClassProtocol = ClassServerAPI()) {
        self.classByIdService = classbyidservice
    }
    
    func getClassesById(id: String) async {
        isLoading = true
        print("Fetching Classes By Id")
        
        defer {
            isLoading = false
            print("Fetching Classes By Id is disclose")
        }
        do {
            
            let response: ClassByIDRes = try await self.classByIdService
                .getClassByID(id: id)
            classroom = response.data
            isFetchingClassById = true
            print(response.data,"class By ID is fetched Succesfully",isFetchingClassById)
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
}
