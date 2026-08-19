//
//  ProfileServerAPI.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/08/2026.
//

import Foundation

class ProfileServerAPI: ProfileProtocol{
    func getProfile() async throws -> ProfileRes {
        do{
       
            let profileRes : ProfileRes = try await APIClient.shared.request(APIEndpoint.profile)
            return profileRes
        }
        catch let error{
            throw error
        }
    }
}
