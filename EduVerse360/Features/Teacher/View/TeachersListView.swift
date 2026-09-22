//
//  TeachersLIst.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import SwiftUI

struct TeachersListView: View {
    @Environment(TabRouter.self) private var router

    @State var viewModel = TeachersListViewModel(
        teacherService: TeacherMockAPI()
    )
    @State private var isLoading = false

    var body: some View {

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 16) {

                HStack {
                    Text("Teachers")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal)

                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.tertiaryText)

                    TextField("Search teachers...", text: $viewModel.searchText)

                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                .padding(.horizontal)

                if viewModel.teachers.isEmpty {
                    if !isLoading {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(systemName: "person.3")
                                .font(.system(size: 48))
                                .foregroundStyle(Color.tertiaryText)
                            Text("No teachers available")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.secondaryText)
                            Text("Teachers will appear here once they are added.")
                                .font(.subheadline)
                                .foregroundStyle(Color.tertiaryText)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, 40)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.teachers) { teacher in
                                Button {
                                    router.push(SharedRoute.teacherDetails(id: teacher.id))
                                } label: {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.tealTint)
                                            .frame(width: 44, height: 44)
                                            .overlay {
                                                Text(initials(for: teacher.username))
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(Color.primary)
                                            }

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(teacher.username)
                                                .font(.headline)
                                                .foregroundStyle(Color.secondaryText)

                                            Text(teacher.email)
                                                .font(.caption)
                                                .foregroundStyle(Color.tertiaryText)
                                                .lineLimit(1)
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .font(.footnote)
                                            .foregroundStyle(Color.tertiaryText)
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .padding(.top)
        }
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
        .task {
            isLoading = true
            await viewModel.loadTeachers()
            isLoading = false
        }
        .onChange(of: viewModel.searchText) {
            Task {
                await viewModel.searchTeachers()
            }
        }
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
        TeachersListView()
    }
    .environment(TabRouter())
}
