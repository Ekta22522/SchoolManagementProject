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
    var username: String?
    var user: UserModel?
    var token: String?
    var role: UserRole?
    var isLoggedIn = false

    var activeRole: UserRole { role ?? .student }

    init() {
        token = UserDefaultsManager.shared.read(key: .token)
        if let data = UserDefaultsManager.shared.readData(key: .user),
           let savedUser = try? JSONDecoder().decode(UserModel.self, from: data) {
            user = savedUser
        }
        if let rawRole = UserDefaultsManager.shared.read(key: .role) {
            role = UserRole(rawValue: rawRole)
        }
        isLoggedIn = (token != nil)
    }

    func loginSucceeded(user: UserModel) {
        self.user = user
        self.role = UserRole(rawValue: user.role)
        self.token = UserDefaultsManager.shared.read(key: .token)
        if let data = try? JSONEncoder().encode(user) {
            UserDefaultsManager.shared.save(data: data, key: .user)
        }
        if let role {
            UserDefaultsManager.shared.save(data: role.rawValue, key: .role)
        }
        isLoggedIn = true
    }

    func logout() {
        UserDefaultsManager.shared.remove(key: .token)
        UserDefaultsManager.shared.remove(key: .user)
        UserDefaultsManager.shared.remove(key: .role)
        username = nil
        user = nil
        token = nil
        role = nil
        isLoggedIn = false
    }
}
