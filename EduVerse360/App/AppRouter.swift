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
    case register
//    case dashboard
    case profile
    case mainTab
    case forgotPassword
    case studentDetails(id: Int)
    case teacherDetails(id:Int)
    case verifyRegisterationOTP(email:String)
    case verifyOtp(email:String)
    case resetPassword(email:String)
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
        path = NavigationPath()
        path.append(Router.login)
        
    }
    
    
    func goToRegister(){
        path.append(Router.register)
        
    }
    
    func goToVerifyRegisterationOTP(email: String){
        path.append(Router.verifyRegisterationOTP(email:email))
    }

    func goToVerifyOtp (email:String){
        path.append(Router.verifyOtp(email: email))
    }
    func goToForgotPassword(){
        path.append(Router.forgotPassword)
    }
    
    func goToResetPassword(email:String){
        path.append(Router.resetPassword(email: email))
    }
    func goToStudentDetail(id: Int){
        path.append(Router.studentDetails(id: id))
    }
    
    func goToTeacherDetail(id:Int){
        path.append(Router.teacherDetails(id: id))
    }
}

