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
    @State var viewModel = ProfileViewModel(profileservice: ProfileServerAPI())

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.fill")
                .foregroundColor(Color.primary)
                .font(.largeTitle)
                .fontWeight(.bold)

            if let user = viewModel.userModel {

                Text("User Id: \(user.id)")
                Text("UserName: \(user.username)")
                Text("Email: \(user.email)")
                Text("Role: \(user.role)")
                Text("isVerified: \(user.isVerified ? "Yes" : "No")")
                Text("createdAt: \(user.createdAt)")

            } else if viewModel.isLoading {

                ProgressView("Loading profile...")

            } else {

                Text("No profile data")
            }

            Button(
                action: {
                    session.logout()
                    router.goToLogin()

                    print("logout successfully")
                },
                label: {
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
        .task {
            await viewModel.getProfileData()
        }
    }
}

#Preview {
    ProfileView()
}
