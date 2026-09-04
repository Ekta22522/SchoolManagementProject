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
                        case .allClasses:
                            AllClassesView()
                        case .profile:
                            ProfileView()
                      
                        case .verifyRegisterationOTP(let email):
                            VerifyRegistrationView(email: email)
                        case .forgotPassword:
                            ForgotPasswordView()
    
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
                        case.classSection(let classID):
                            ClassSectionView(classId:classID)
                        case.sectionById(let sectionID):
                            SectionByIdView(sectionId: sectionID)
                        case.updateSection(let sectionID):
                            UpdateSectionView(sectionId: sectionID)
                            
                        case.deleteSection(let sectionID):
                            DeleteSectionView(sectionId: sectionID)
                        case.onlineClass:
                           CreateOnlineClassView()
                        case.allOnlineClass:
                            ListOnlineClassView()
                        case.onlineClassById(let onlineClassID):
                            OnlineClassByIdView(onlineClassId: onlineClassID)
                        case.updateOnlineClass(let onlineClassID):
                            UpdateOnlineClassView(onlineClassId: onlineClassID)
                        case.deleteOnlineClass(let onlineClassID):
                            DeleteOnlineClassView( onlineClassId: onlineClassID)
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

    @Environment(NavigationRouter.self) private var router

    var body: some View {

        if session.isLoggedIn {

            MainTabView()

        } else {

            switch router.authScreen {

            case .login:
                LoginView()
                
            case.mainTab:
                MainTabView()
                
            case .register:
                RegisterSessionView()
            case .verifyOtp(let email):
                VerifyOtpView(email: email)
                
            }
        }
    }
}
