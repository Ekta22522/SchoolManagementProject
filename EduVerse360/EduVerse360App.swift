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
    @State private var authRouter = AuthRouter()
    @State private var tabRouter = TabRouter()

    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(session)
                .environment(authRouter)
                .environment(tabRouter)
        }
    }
}

struct StartView: View {

    @Environment(UserSession.self) private var session

    var body: some View {
        if session.isLoggedIn {
            MainTabView()
        } else {
            AuthStackView()
        }
    }
}

struct AuthStackView: View {

    @Environment(AuthRouter.self) private var authRouter

    var body: some View {
        NavigationStack(path: Binding(
            get: { authRouter.path },
            set: { authRouter.path = $0 }
        )) {
            LoginView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .register:
                        RegisterSessionView()
                    case .verifyRegistrationOTP(let email):
                        VerifyRegistrationView(email: email)
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .verifyOtp(let email):
                        VerifyOtpView(email: email)
                    case .resetPassword(let email):
                        ResetPasswordView(email: email)
                    }
                }
        }
    }
}
