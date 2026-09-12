//
//  AuthRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class AuthRouter {
    var path = NavigationPath()

    func push<V: Hashable>(_ value: V) {
        path.append(value)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
