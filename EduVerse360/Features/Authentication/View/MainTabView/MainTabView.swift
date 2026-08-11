//
//  MainTabView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//

import SwiftUI

struct MainTabView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem{
                    Label("Home",systemImage: "house")
                }
            
            RegisterSessionView()
                 .tabItem{
                    Label("Register",systemImage: "house")
                }
            
            
            StudentsListView()
                .tabItem{
                    Label("Students",systemImage: "graduationcap.fill")
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
