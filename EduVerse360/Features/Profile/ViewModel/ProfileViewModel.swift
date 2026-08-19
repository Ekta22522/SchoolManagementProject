//
//  ProfileViewModel.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/08/2026.
//
import Foundation
import Observation

@Observable
class ProfileViewModel{
    
    var userModel : UserModel?
    
    var isLoading = false
    var errorMessage: String?
    var isProfileSuccess = false
    private let profileService : ProfileProtocol
    
    init(profileservice: ProfileProtocol = ProfileServerAPI()) {
        self.profileService = profileservice
    }
    
    func getProfileData() async{
     print("profile processing is started")
    isLoading = true
        defer{
            isLoading = false
            print("profile disclose")
        }
        
        do{
            let profileRes = try await self.profileService.getProfile()
            
            userModel = profileRes.user
            isProfileSuccess  = true
            print("profile success",isProfileSuccess)
            
        }catch let error{
            errorMessage = error.localizedDescription
        }
        
        
    }
    
}
