//
//  AllClassesViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import Foundation
import Observation
@Observable

class AllClassesViewModel{
    var classes: [Class] = []
    var isLoading = false
    var isFetchingAllClasses = false
    var errorMessage: String?
    
    private let allClassService : ClassProtocol
    init(allclassservice:ClassProtocol = ClassServerAPI()){
            self.allClassService  = allclassservice
        }
    
    func getAllClasses() async {
        print("Fetching all classes...")
        
        isLoading = true
        defer{
            isLoading = false
            print("disclose all classes")
        }
        
        do{
            let allclassesRes : AllclassesRes = try await self.allClassService.getAllClasses()
            classes = allclassesRes.data
            isFetchingAllClasses = true
            print("All Classes are fetched Successfully",isFetchingAllClasses)
            
        }catch{
            self.errorMessage = error.localizedDescription
        }
        
    }
}
