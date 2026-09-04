//
//  ListOnlineClassViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 01/09/2026.
//

import Foundation
import Observation

@MainActor
@Observable

class ListOnlineClassViewModel {
    var onlineClass : [OnlineClass]?
    var isLoading = false
    var isListOnlineClassSuccess = false
    var title = ""
    var description = ""
    var className = ""
    var section = ""
    var subject = ""
    var durationMinutes = 0
    var errorMessage : String?

    
    private let listOnlineClassService : OnlineClassProtocol
    
    init(listonlineclassservice : OnlineClassProtocol = OnlineClassProtocolImp()){
        self.listOnlineClassService = listonlineclassservice
    }
    func getListOnlineClass ()async {
        print("Listing online class is started")
        isLoading = true
        
        defer{
            isLoading = false
            print("Listing online class is finished")
        }
        do{
            let response : ListOnlineClassRes = try await self.listOnlineClassService.readAllOnlineClass()
            onlineClass = response.data
            isListOnlineClassSuccess = true
            print("Successfully done",isListOnlineClassSuccess)
        }catch{
            errorMessage = error.localizedDescription
        }
    }
    
}
