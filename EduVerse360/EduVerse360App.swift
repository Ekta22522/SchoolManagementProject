//
//  EduVerse360App.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/07/2026.
//

import SwiftUI

@main
struct EduVerse360App: App {
    
    @State private var session = UserSession()
    @State private var router = NavigationRouter()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                StartView()
                    .navigationDestination(for: Router.self) { route in
                        switch route {
                        case .mainTab:
                            MainTabView()
                        case .profile:
                            ProfileView()
                        case.login:
                            LoginView()
                        case.register:
                            RegisterSessionView()
                        case.verifyRegisterationOTP(let email):
                            VerifyRegistrationView(email:email)
                        case.forgotPassword:
                            ForgotPasswordView()
                        case.verifyOtp(let email):
                            VerifyOtpView(email:email)
                        case.resetPassword(let email):
                            ResetPasswordView(email:email)
                            
                            
                        case .studentDetails(let id):
                            StudentDetailView(studentId: id)
                            
                        case.teacherDetails(let id):
                            TeacherDetailView(teacherId: id)
                        }
                    }
            }
            
            .environment(session)
            .environment(router)
        }
    }
}



struct StartView: View {
    
    @Environment(UserSession.self) private var session
    
    var body: some View {
        if session.isLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
        
    }
}
