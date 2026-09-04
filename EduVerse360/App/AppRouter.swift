//
//  AppRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 15/07/2026.
//

import Foundation
import SwiftUI
import Observation

enum AuthScreen {
    case mainTab
    case login
    case register
    case verifyOtp(email:String)
}


enum Router : Hashable{

//    case dashboard
    case profile
    case forgotPassword
    case studentDetails(id: Int)
    case teacherDetails(id:Int)
    case verifyRegisterationOTP(email:String)
    
    case resetPassword(email:String)
    case classes
    case allClasses
    case updateClass(id:String)
    case classById(id:String)
    case deleteClass(id:String)
    case createSection(id:String)
    case listSection
    case classSection(id:String)
    case sectionById(id:Int)
    case updateSection(id:Int)
    case deleteSection(id:Int)
    case onlineClass
    case allOnlineClass
    case onlineClassById(id:Int)
    case updateOnlineClass(id:Int)
    case deleteOnlineClass(id:Int)
    
//    case settings
}

@Observable
class NavigationRouter{
    var authScreen: AuthScreen = .login
    var path = NavigationPath()
    
//    func gotoDashboard(){
//        path.append(Router.dashboard)
//    }
    
    
    func pop(){
        path.removeLast()
    }
    
    func goToMainTab(){
       authScreen = .mainTab
       path = NavigationPath()
        
        
    }
    
    func goToProfile(){
        path.append(Router.profile)
    }
    
    func goToLogin() {
        authScreen = .login
        path = NavigationPath()
    }

    func goToRegister() {
        authScreen = .register
        path = NavigationPath()
    }
    
    func goToVerifyRegisterationOTP(email: String){
        path.append(Router.verifyRegisterationOTP(email:email))
    }

    func goToVerifyOtp (email:String){
        authScreen = .verifyOtp(email: email)
        path = NavigationPath()
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
    
    func goToClasses(){
        path.append(Router.classes)
    }
    
    func goToAllClasses(){
        path.append(Router.allClasses)
    }
    
    func goToClassById(id:String){
        path.append(Router.classById(id: id))
    }
    
    func goToUpdateClass(id:String){
        path.append(Router.updateClass(id: id))
    }
    
    func goToDeleteClass(id:String){
        path.append(Router.deleteClass(id: id))
    }
    
    func goToCreateSection(id:String){
        path.append(Router.createSection (id: id))
    }
    
    func goToListSection(){
        path.append(Router.listSection)
    }
    func goToClassSection(id:String){
        path.append(Router.classSection(id: id))
    }
    
    func goToSectionById(id:Int){
        path.append(Router.sectionById(id: id))
    }
    
    func goToUpdateSection(id:Int){
        path.append(Router.updateSection(id: id))
    }
    
    func goToDeleteSection (id:Int){
        path.append(Router.deleteSection(id: id))
    }
    
    func goToOnlinceClass(){
        path.append(Router.onlineClass)
    }
    func goToAllOnlineClass(){
        path.append(Router.allOnlineClass)
    }
    
    func goToOnlineClassById(id:Int){
        path.append(Router.onlineClassById(id: id))
    }
    
    func goToUpdateOnlineClass(id:Int){
        path.append(Router.updateOnlineClass(id: id))
    }
    
    func goToDeleteOnlineClass(id:Int){
        path.append(Router.deleteOnlineClass(id: id))
    }
}

