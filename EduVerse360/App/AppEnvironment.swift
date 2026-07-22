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

    var username = "Email"
    var password = "Password"
    var token: String? = UserDefaultsManager.shared.read(key: .token)
    var isLoggedIn = false

    init() {
        token = UserDefaultsManager.shared.read(key: .token)
        isLoggedIn = (token != nil)
    }
    
}
