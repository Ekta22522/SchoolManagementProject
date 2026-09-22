//
//  SettingsView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 14/07/2026.
//
import Foundation
import SwiftUI


struct SettingsView: View {

    @Environment(TabRouter.self) private var router
    @Environment(UserSession.self) private var session

    var body: some View {

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {

                    HStack {
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }

                    // MARK: Account

                    VStack(spacing: 0) {
                        Button {
                            router.push(SharedRoute.profile)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .frame(width: 24)
                                    .foregroundStyle(Color.primary)

                                Text("Profile")
                                    .font(.subheadline)
                                    .foregroundStyle(Color.secondaryText)

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .foregroundStyle(Color.tertiaryText)
                            }
                            .padding()
                        }
                        .buttonStyle(.plain)
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)

                    // MARK: About

                    VStack(alignment: .leading, spacing: 14) {
                        Text("About")
                            .font(.headline)
                            .fontWeight(.semibold)

                        HStack {
                            Text("App")
                                .foregroundStyle(Color.tertiaryText)
                            Spacer()
                            Text("EduVerse360")
                                .foregroundStyle(Color.secondaryText)
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)

                        HStack {
                            Text("Version")
                                .foregroundStyle(Color.tertiaryText)
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(Color.secondaryText)
                                .fontWeight(.semibold)
                        }
                        .font(.subheadline)
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

                    // MARK: Log Out

                    Button(
                        action: {
                            session.logout()
                            router.reset()

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
                    .padding(.top, 8)
                }
                .padding()
            }
        }
    }
}


#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(TabRouter())
    .environment(UserSession())
}
