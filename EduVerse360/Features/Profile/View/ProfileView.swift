//
//  ProfileView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//

import SwiftUI

struct ProfileView: View {

    @Environment(TabRouter.self) private var tabRouter
    @Environment(UserSession.self) private var session
    @State var viewModel = ProfileViewModel(profileservice: ProfileServerAPI())

    var body: some View {

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {

                HStack {
                    Text("Profile")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)

                if let user = viewModel.userModel {

                    ScrollView {
                        VStack(spacing: 16) {

                            // MARK: Header

                            VStack(spacing: 12) {
                                Circle()
                                    .fill(Color.tealTint)
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        Text(initials(for: user.username))
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color.primary)
                                    }

                                Text(user.username)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.secondaryText)

                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.tertiaryText)

                                Text(user.role.capitalized)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 5)
                                    .background(Color.blueTint)
                                    .foregroundStyle(Color.primary)
                                    .clipShape(Capsule())
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)

                            // MARK: Information

                            VStack(alignment: .leading, spacing: 14) {
                                Text("Account Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)

                                detailRow(label: "User ID", value: "\(user.id)")
                                detailRow(label: "Email", value: user.email)
                                detailRow(label: "Role", value: user.role.capitalized)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }

                } else if !viewModel.isLoading {

                    Spacer()

                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.tertiaryText)
                        Text("No profile data")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondaryText)
                        Text("We couldn't load your profile right now.")
                            .font(.subheadline)
                            .foregroundStyle(Color.tertiaryText)
                    }
                    .padding(.horizontal, 40)

                    Spacer()
                }

                // MARK: Log Out

                Button(
                    action: {
                        session.logout()
                        tabRouter.reset()

                        print("logout successfully")
                    },
                    label: {
                        Text("Log Out")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }
                )
                .padding(.horizontal)
                .padding(.bottom)
            }
            .padding(.top)
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Loading profile...")
            }
        }
        .task {
            await viewModel.getProfileData()
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.tertiaryText)
            Spacer()
            Text(value)
                .foregroundStyle(Color.secondaryText)
                .fontWeight(.semibold)
                .multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }

    private func initials(for name: String?) -> String {
        guard let name, !name.isEmpty else { return "?" }
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.count > 1 ? (parts.last?.first.map(String.init) ?? "") : ""
        return (first + last).uppercased()
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(TabRouter())
    .environment(UserSession())
}
