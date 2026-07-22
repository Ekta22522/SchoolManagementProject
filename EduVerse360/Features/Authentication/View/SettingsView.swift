//
//  SettingsView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//
import Foundation
import SwiftUI


struct SettingsView: View {
  
    @Environment(NavigationRouter.self) private var router
    var body: some View {
        VStack(spacing: 20){
        HStack() {
            Image(systemName: "gearshape.fill")
                .font(.largeTitle)
                .foregroundColor(.primary)
                .padding()
            
            Text("Settings View")
                .font(.title)
                .fontWeight(.semibold)
        }
        Button(action: {
            router.goToProfile()
        } , label: {
            HStack() {
                Image(systemName: "person")
                
                Text("Profile")
            }
            .foregroundColor(Color.white)
            .fontWeight(.bold)
            
            
        }
        )
        .padding()
        .background(Color.primary)
        .cornerRadius(20)
    }
            
            
          
            }
        
        
    }


#Preview {
    SettingsView()
        
}
