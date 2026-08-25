//
//  UpdateViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import Foundation
import Observation

@Observable
class UpdateClassViewModel{
    var className = ""
    var description = ""
    var classNameError : String?
    var descriptionError : String?
    var section : Section?
    var errorMessage : String?
    var isLoading = false
    var classroom : Class?
    var isUpdateClass = false
    
    private let updateService : ClassProtocol
    init(updateservice : ClassProtocol = ClassServerAPI()){
        self.updateService = updateservice
    }
    
    func getClassById (id:String) async{
        print("Update operation is started")
        isLoading = true
        defer{
            isLoading = false
            print("Update operation is finished")
        }
        
        do{
            let response = try await self.updateService.getClassByID(id: id)
            classroom = response.data
            className = response.data.className
            description = response.data.description
     
            print("Class Updated Successfully",isUpdateClass)
            
           
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    
    func updateClass(id: String) async {
        
       
        
        do{
            
            let classReq = ClassReq(className: className, description: description)
            let response = try await self.updateService.updateClass(id: id, req: classReq)
            isUpdateClass = true
            
        }catch{
            errorMessage = error.localizedDescription
        }
        
        
    }
}

