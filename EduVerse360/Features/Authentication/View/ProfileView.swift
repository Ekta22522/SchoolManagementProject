//
//  ProfileView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//

import SwiftUI

struct ProfileView: View {
    
    @Environment(NavigationRouter.self) private var router
    @Environment(UserSession.self) private var session

    
    var body: some View {
        VStack(spacing:10) {
            Image(systemName: "person.fill")
                .foregroundColor(Color.primary)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(" Ekta Rai")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
            
            Button(action:{
                session.logout()
               
                print("logout successfully")
            }, label: {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
            }
            )
            
            .frame(maxWidth: 120, maxHeight: 40)
            .padding()
            .background(Color.primary)
            .cornerRadius(20)
            
            
        }
    }
}

#Preview {
    ProfileView()
}
