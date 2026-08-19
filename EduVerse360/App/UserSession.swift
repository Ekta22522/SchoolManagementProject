//
//  AppRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 15/07/2026.
//

import Foundation
import Observation


@Observable
class UserSession {
    var username:String?
    var user: UserModel?
    var token: String? = UserDefaultsManager.shared.read(key: .token)
    var isLoggedIn = false

    init() {
        isLoggedIn = (token != nil)
    }
    
    func logout() {
           UserDefaultsManager.shared.remove(key: .token)
           user = nil
           isLoggedIn = false
       }
    
    func updateUserModel(model: UserModel?){
        self.user = model
    }
    
}
