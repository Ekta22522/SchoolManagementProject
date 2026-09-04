//
//  OnlineClassByIDViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable

class OnlineClassByIDViewModel{
    var onlineClassId : OnlineClass?
    var isLoading = false
    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var meetingUrl = ""
    var scheduledAt = ""
    var durationMinutes = 0
    var errorMessage : String?
    var isOnlineClassByIDSuccess = false
    
    private let onlineClassByIdService : OnlineClassProtocol
    init(onlineclassbyidservice:OnlineClassProtocol = OnlineClassProtocolImp()){
        self.onlineClassByIdService = onlineclassbyidservice
    }
    
    func getOnlineClassById (id: Int) async {
        isLoading = true
        print("process is started")
        
        defer{
            isLoading = false
            print("process is finished")
        }
        
        do{
            let response : OnlineClassByIdRes = try await self.onlineClassByIdService.getOnlineClassById(id: id)
            onlineClassId = response.data
            
        }catch{
            errorMessage = error.localizedDescription
        }
    }
}
