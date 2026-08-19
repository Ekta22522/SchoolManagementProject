//
//  ClassViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//
import Foundation
import Observation
@Observable

class ClassViewModel{
    var className = ""
    var description = ""
    var classNameError : String?
    var descriptionError : String?
    var errorMessage : String?
    var isLoading = false
    var isclassSuccess = false
    
    private let classService : ClassProtocol
    init(
    classservice:ClassProtocol = ClassServerAPI()){
        self.classService = classservice
    }
    
    
    func classes () async {
        isLoading = true
        print("Class processing is started")
        
        defer{
            isLoading = false
            print("Class Processing is finished")
        }
        
        do{
            let classReq = ClassReq(className: className, description: description)
            let classRes = try await self.classService.getClass(req: classReq)
            isclassSuccess = true
            print(classReq.className,"Class Successfully submitted",isclassSuccess)
         
            
        }catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
}
