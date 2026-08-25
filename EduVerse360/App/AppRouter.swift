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
    case classes
    case allClasses
    case updateClass(id:String)
    case classById(id:String)
    case deleteClass(id:String)
    case createSection(id:String)
    case listSection
    case classSectionById(id:String)
    case sectionById(id:Int)
    case updateSection(id:Int)
    case deleteSection(id:Int)
    
//    case settings
}

@Observable
class NavigationRouter{
    var path = NavigationPath()
    
//    func gotoDashboard(){
//        path.append(Router.dashboard)
//    }
    
    
    func pop(){
        path.removeLast()
    }
    
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
    func goToClassSectionById(id:String){
        path.append(Router.classSectionById(id: id))
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
}

