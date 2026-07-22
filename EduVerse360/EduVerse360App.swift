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
                        case.forgotPassword:
                            ForgotPassword()
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
