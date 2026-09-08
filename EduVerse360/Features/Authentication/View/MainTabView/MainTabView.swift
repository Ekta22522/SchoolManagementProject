//
//  MainTabView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(NavigationRouter.self) private var router
    @Environment(UserSession.self) private var session
    
    let role: UserRole
    
    var body: some View {
        TabView {
            
            switch role {
                
            // MARK: - SCHOOL ADMIN
            case .schoolAdmin:
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                TeacherOnlyView()
                    .tabItem {
                        Label("Teachers Only", systemImage: "graduationcap.fill")
                    }
                
                StudentsListView()
                    .tabItem {
                        Label("Students", systemImage: "graduationcap.fill")
                    }
                
                AllClassesView()
                    .tabItem {
                        Label("Classes", systemImage: "applepencil.tip")
                    }
                
                TeachersListView()
                    .tabItem {
                        Label("Teachers", systemImage: "person.3")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                
                
            // MARK: - TEACHER
            case .teacher:
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                AllTeacherAssignmentView()
                    .tabItem {
                        Label("Work", systemImage: "text.document")
                    }
                
                TeacherOnlyView()
                    .tabItem {
                        Label("Classes", systemImage: "sparkle.text.clipboard")
                    }
                
                StudentsListView()
                    .tabItem {
                        Label("Students", systemImage: "graduationcap.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                
                
            // MARK: - STUDENT
            case .student:
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                AllClassesView()
                    .tabItem {
                        Label("Classes", systemImage: "applepencil.tip")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
                
                
            // MARK: - SUPER ADMIN
            case .superAdmin:
                
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                TeacherOnlyView()
                    .tabItem {
                        Label("Teachers Only", systemImage: "graduationcap.fill")
                    }
                
                StudentsListView()
                    .tabItem {
                        Label("Students", systemImage: "graduationcap.fill")
                    }
                
                AllClassesView()
                    .tabItem {
                        Label("Classes", systemImage: "applepencil.tip")
                    }
                
                TeachersListView()
                    .tabItem {
                        Label("Teachers", systemImage: "person.3")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape")
                    }
            }
        }
    }
}

#Preview {
    MainTabView(role: .student)
}
