//
//  HomeView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/07/2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(UserSession.self) private var session

    var body: some View {
        switch session.activeRole {
        case .schoolAdmin, .superAdmin, .teacher:
            DashboardView()
        case .student:
            StudentHomeView()
        }
    }
}

private struct StudentHomeView: View {
    @Environment(UserSession.self) private var session
    @Environment(TabRouter.self) private var router

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Welcome back, \(session.user?.username ?? "")")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 8)

                HomeCard(
                    icon: "text.document",
                    title: "My Assignments",
                    subtitle: "View your assignments"
                ) {
                    router.selection = .work
                }

                HomeCard(
                    icon: "video",
                    title: "Online Classes",
                    subtitle: "Join your online classes"
                ) {
                    router.selection = .classes
                }

                Spacer()
            }
            .padding()
        }
        .background(Color.pageBackground.ignoresSafeArea())
    }
}

private struct HomeCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tertiary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 8)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .environment(UserSession())
        .environment(TabRouter())
}
