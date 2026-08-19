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
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Label("Home",systemImage: "house")
                }
            
            if session.user?.role == UserRole.teacher.rawValue {
                TeacherOnlyView()
                    .tabItem{
                        Label("Teachers only",systemImage: "graduationcap.fill")
                    }
            }else{
                StudentsListView()
                    .tabItem{
                        Label("Students",systemImage: "graduationcap.fill")
                    }
                
            }
            NavigationStack {
                AllClassesView()
            }
                .tabItem{
                    Label("Class",systemImage:"applepencil.tip")
                }
            
            TeachersListView()
                .tabItem{
                    Label("Teachers",systemImage: "person.3")
                }
            
        
            SettingsView()
                .tabItem{
                    Label("Setting",systemImage: "gearshape")
                }
                
            
            
        }
    }
}

#Preview {
    MainTabView()
}
