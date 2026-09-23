//
//  StudentByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import SwiftUI

struct StudentByIdView: View {

    let studentId: Int

    @Environment(TabRouter.self) private var router
    @State var viewModel = StudentByIdViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.horizontal)
                }

                if let student = viewModel.student {
                    profileHeader(for: student)

                    infoCard(title: "Academic Details", icon: "book.fill") {
                        InfoRow(label: "Admission Number", value: student.admissionNumber)
                        InfoRow(label: "Major", value: student.major)
                        InfoRow(label: "Enrollment Year", value: "\(student.enrollmentYear)")
                        InfoRow(label: "Status", value: student.status)
                        InfoRow(label: "Alumni", value: student.isAlumni ? "Yes" : "No")
                    }

                    infoCard(title: "Personal Details", icon: "person.fill") {
                        InfoRow(label: "Date of Birth", value: student.dateOfBirth)
                        InfoRow(label: "Gender", value: student.gender)
                        InfoRow(label: "Address", value: student.address)
                    }

                    infoCard(title: "Guardian Details", icon: "person.2.fill") {
                        InfoRow(label: "Guardian Name", value: student.guardianName)
                        InfoRow(label: "Guardian Phone", value: student.guardianPhone)
                    }
                } else if !viewModel.isLoading {
                    Text("No student found")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 300)
                }
            }
            .padding()
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .navigationTitle("Student Details")
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Loading student...")
            }
        }
        .onAppear {
            print("Loading student with id:", studentId)
            Task {
                await viewModel.studentById(id: studentId)
            }
        }
    }

    private func profileHeader(for student: Student) -> some View {
        VStack(spacing: 12) {
            Circle()
                .fill(Color.teal.opacity(0.15))
                .frame(width: 80, height: 80)
                .overlay {
                    Text(initials(for: student.userName))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.teal)
                }

            Text(student.userName ?? "N/A")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.secondaryText)

            Text(student.email ?? "N/A")
                .font(.subheadline)
                .foregroundStyle(Color.tertiaryText)

            if let role = student.role {
                Text(role.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.blueTint)
                    .foregroundStyle(Color.primary)
                    .cornerRadius(12)
            }

            Button {
                router.push(StudentRoute.update(student: student))
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "pencil")
                    Text("Edit")
                }
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color.teal)
                .foregroundStyle(.white)
                .cornerRadius(14)
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .background(Color.white)
        .cornerRadius(16)
    }

    private func infoCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(Color.primary)

            Divider()
                .overlay(Color.divider)

            content()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }

    private func initials(for name: String?) -> String {
        guard let name, !name.isEmpty else { return "?" }
        let parts = name.split(separator: " ")
        let first = parts.first?.first.map(String.init) ?? ""
        let last = parts.count > 1 ? (parts.last?.first.map(String.init) ?? "") : ""
        return (first + last).uppercased()
    }
}

struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.tertiaryText)
                .frame(width: 130, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        StudentByIdView(studentId: 1)
    }
}
