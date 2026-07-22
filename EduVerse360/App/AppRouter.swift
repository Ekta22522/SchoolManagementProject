//
//  AppRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 15/07/2026.
//

import Foundation
import SwiftUI
import Observation

enum Router : Hashable{
    case login
//    case dashboard
    case profile
    case mainTab
    case forgotPassword
//    case settings
}

@Observable
class NavigationRouter{
    var path = NavigationPath()
    
//    func gotoDashboard(){
//        path.append(Router.dashboard)
//    }
    
    func goToMainTab(){
        path.append(Router.mainTab)
    }
    func goToProfile(){
        path.append(Router.profile)
    }
    
    func goToLogin(){
        path.append((Router.login))
    }
//    func goToSettings(){
//        path.append(Router.settings)
//    }
    
    func goToForgotPassword(){
        path.append(Router.forgotPassword)
    }
}

