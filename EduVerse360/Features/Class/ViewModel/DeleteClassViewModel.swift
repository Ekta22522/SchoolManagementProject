//
//  DeleteClassViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

//
//  UpdateViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import Foundation
import Observation

@Observable
class DeleteClassViewModel{
    var className = ""
    var description = ""
    var classNameError : String?
    var descriptionError : String?
    var errorMessage : String?
    var isLoading = false
    var classroom : Class?
    var isDeleteClass = false
    
    private let deleteService : ClassProtocol
    init(deleteservice : ClassProtocol = ClassServerAPI()){
        self.deleteService = deleteservice
    }
    
    func getClassById (id:String) async{
        print("Delete operation is started")
        isLoading = true
        defer{
            isLoading = false
            print("Delete operation is finished")
        }
        
        do{
            let response = try await self.deleteService.getClassByID(id: id)
            classroom = response.data
            className = response.data.className
            description = response.data.description
           
     
            print("Class Deleted Successfully",isDeleteClass)
            
           
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
    
    func deleteClass(id: String) async {
        
       
        
        do{
            
            let classReq = ClassReq(className: className, description: description)
            let response = try await self.deleteService.deleteClass(id: id, req: classReq)
            isDeleteClass = true
            
        }catch{
            errorMessage = error.localizedDescription
        }
        
        
    }
}

