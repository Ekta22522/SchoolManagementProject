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
                        case .allClasses:
                            AllClassesView()
                        case .profile:
                            ProfileView()
                        case .login:
                            LoginView()
                        case .register:
                            RegisterSessionView()
                        case .verifyRegisterationOTP(let email):
                            VerifyRegistrationView(email: email)
                        case .forgotPassword:
                            ForgotPasswordView()
                        case .verifyOtp(let email):
                            VerifyOtpView(email: email)
                        case .resetPassword(let email):
                            ResetPasswordView(email: email)

                        case .studentDetails(let id):
                            StudentDetailView(studentId: id)

                        case .teacherDetails(let id):
                            TeacherDetailView(teacherId: id)
                        case .classes:
                            ClassView()
                        case .classById(let classID):
                            ClassByIdView(classId: classID)
                        case.updateClass(let classID):
                            UpdateClassView(classId:classID)
                        case.deleteClass(let classID):
                           DeleteClassView(classId:classID)
                        case.createSection(let classID):
                            SectionView(classId: classID)
                        case.listSection:
                            ListSectionView()
                        case.classSectionById(let classID):
                            ClassSectionByIdView(classId:classID)
                        case.sectionById(let sectionID):
                            SectionByIdView(sectionId: sectionID)
                        case.updateSection(let sectionID):
                            UpdateSectionView(sectionId: sectionID)
                            
                        case.deleteSection(let sectionID):
                            DeleteSectionView(sectionId: sectionID)
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
