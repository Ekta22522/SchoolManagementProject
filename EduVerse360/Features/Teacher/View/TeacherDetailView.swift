//
//  TeacherDetailView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 28/07/2026.
//

import SwiftUI

struct TeacherDetailView: View {

    let teacherId : Int

    @State private var viewModel = TeacherDetailViewModel(teacherService: TeacherMockAPI())
    @State private var isLoading = false

    var body: some View {

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            if isLoading {
                ProgressView()
            } else if let teacher = viewModel.teacher {
                ScrollView {
                    VStack(spacing: 16) {

                        // MARK: Header

                        VStack(spacing: 12) {
                            Circle()
                                .fill(Color.tealTint)
                                .frame(width: 80, height: 80)
                                .overlay {
                                    Text(initials(for: teacher.username))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.primary)
                                }

                            Text(teacher.username)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.secondaryText)

                            Text(teacher.email)
                                .font(.subheadline)
                                .foregroundStyle(Color.tertiaryText)

                            Text(teacher.role.capitalized)
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
                            Text("Teacher Information")
                                .font(.headline)
                                .fontWeight(.semibold)

                            detailRow(label: "Teacher ID", value: "\(teacher.id)")
                            detailRow(label: "Email", value: teacher.email)
                            detailRow(label: "Role", value: teacher.role.capitalized)
                            if !teacher.createdAt.isEmpty {
                                detailRow(label: "Created", value: teacher.createdAt)
                            }
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
                    .padding()
                }
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "person.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.tertiaryText)
                    Text("Teacher not found")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.secondaryText)
                }
            }
        }
        .task {
            print("Loading teacher with id:", teacherId)
            isLoading = true
            await viewModel.loadTeacherDetail(by: teacherId)
            isLoading = false
        }
        .navigationTitle("Teacher Details")
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
        TeacherDetailView(teacherId: 3)
    }
    .environment(TabRouter())
}
