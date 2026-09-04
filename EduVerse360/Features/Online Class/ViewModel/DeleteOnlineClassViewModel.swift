//
//  DeleteOnlineClassViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 04/09/2026.
//


import Foundation
import Observation
@Observable

class DeleteOnlineClassViewModel{

    var isLoading = false
    var isSuccess = false
    var title = ""
    var className = ""
    var section = ""
    var subject = ""
    var errorMessage : String?
    var titleError:String?
    
    
    private let deleteOnlineClassService : OnlineClassProtocol
    
    init(deleteonlineclassservice : OnlineClassProtocol = OnlineClassProtocolImp()){
        self.deleteOnlineClassService = deleteonlineclassservice
    }
    
    func getOnlineClassId(id: Int) async{
        isLoading = true
        print("online class by id process is started")
        defer{
           isLoading = false
            print("online class by id process is ended")
        }
        
        do{
          
            let response : OnlineClassByIdRes = try await self.deleteOnlineClassService.getOnlineClassById(id: id)
            title = response.data.title ?? ""
            className = response.data.className
            section = response.data.section
            subject = response.data.subject
            print("Successfully Delete")
        }catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func deleteOnlineClass(id:Int) async{
        isLoading = true
        print(" Delete online class process is started")
        
        defer{
           isLoading = false
            print("Delete online class process isended")
        }
        
        do{
            let response : DeleteOnlineClassRes = try await self.deleteOnlineClassService.getDeleteOnlineClass(id: id)
            isSuccess = true
            print("Deleted Successfully")
            
        }catch
        {
            errorMessage = error.localizedDescription
        }
    }
}
