//
//  UpdateOnlineClassViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 02/09/2026.
//

import Foundation
import Observation
@Observable

class UpdateOnlineClassViewModel{

    var isLoading = false
    var isSuccess = false
    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var meetingUrl = ""
    var scheduledDate: Date = Date()
    var durationMinutes = 60
    var errorMessage : String?
    var descriptionError: String?
    var meetingUrlError: String?
    var titleError: String?
    var classNameError: String?
    var sectionError: String?
    var subjectError: String?
    var scheduledAtError: String?
    var durationMinutesError: String?
    
    let durationOptions = [30, 45, 60, 90, 120]
    
    private let updateOnlineClassService : OnlineClassProtocol
    
    init(updateonlineclassservice : OnlineClassProtocol = OnlineClassProtocolImp()){
        self.updateOnlineClassService = updateonlineclassservice
    }
    
    func getOnlineClassId(id: Int) async{
        isLoading = true
        print("online class by id process is started")
        defer{
           isLoading = false
            print("online class by id process is ended")
        }
        
        do{
          
            let response : OnlineClassByIdRes = try await self.updateOnlineClassService.getOnlineClassById(id: id)
            title = response.data.title ?? ""
            className = response.data.className
            description = response.data.description
            section = response.data.section
            subject = response.data.subject
            description = response.data.description
            meetingUrl = response.data.meetingUrl
            let formatter = ISO8601DateFormatter()

            let scheduledAt = formatter.date(
                from: response.data.scheduledAt
            )
            scheduledDate = scheduledAt ?? Date()
            durationMinutes = response.data.durationMinutes
            
            
            print("Successfully done")
        }catch {
            errorMessage = error.localizedDescription
        }
        
    }
    
    func getUpdateOnlineClass(id:Int) async{
        isLoading = true
        print(" Update online class process is started")
        
        defer{
           isLoading = false
            print("Update online class process isended")
        }
        
        do{
            
            let formatter = ISO8601DateFormatter()

            let scheduledAt = formatter.string(
                from: scheduledDate 
            )
            let request = UpdateOnlineClassReq(title: title,
                                               description: description,
                                               className: className,
                                               section: section,
                                               subject: subject,
                                               meetingUrl: meetingUrl,
                                               scheduledAt: scheduledAt,
                                               durationMinutes: durationMinutes)
            let response : UpdateOnlineClassRes = try await self.updateOnlineClassService.updateOnlineClass(id: id, req: request)
         
            isSuccess = true
            print("Updated Successfully")
            
        }catch
        {
            errorMessage = error.localizedDescription
        }
    }
}
