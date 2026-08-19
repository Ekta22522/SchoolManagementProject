//
//  UpdateViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import Foundation
import Observation

@Observable
class UpdateViewModel{
    var className = ""
    var description = ""
    var classNameError : String?
    var descriptionError : String?
    var errorMessage : String?
    var isLoading = false
    var classroom : Class?
    var isUpdateClass = false
    
    private let updateService : ClassProtocol
    init(
    updateservice : ClassProtocol = ClassServerAPI()){
        self.updateService = updateservice
    }
    
    func updateClassById () async{
        print("Update operation is started")
        isLoading = true
        defer{
            isLoading = false
            print("Update operation is finished")
        }
        
        do{
            let response: UpdateClassRes = try await self.updateService.updateClass(id: "")
            classroom = response.data
            isUpdateClass = true
            print("Class Updated Successfully",isUpdateClass)
            
           
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}

