//
//  StudentsListView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import SwiftUI

struct StudentsListView: View {
    @Environment(TabRouter.self) private var router
    @State var viewModel = StudentListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }

            if viewModel.students.isEmpty {
                if !viewModel.isLoading {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.3")
                            .font(.largeTitle)
                            .foregroundStyle(Color.tertiaryText)
                        Text("No students available")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
            } else {
                List(viewModel.students, id: \.id) { student in
                    NavigationLink(value: StudentRoute.studentById(id: student.id)) {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.teal.opacity(0.15))
                                .frame(width: 40, height: 40)
                                .overlay {
                                    Text(initials(for: student.userName))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.teal)
                                }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(student.userName ?? "N/A")
                                    .font(.headline)
                                    .foregroundStyle(Color.secondaryText)

                                Text(student.email ?? "N/A")
                                    .font(.caption)
                                    .foregroundStyle(Color.tertiaryText)
                                    .lineLimit(1)

                                Text("\(student.admissionNumber) · \(student.major) · \(student.enrollmentYear)")
                                    .font(.caption2)
                                    .foregroundStyle(Color.tertiaryText)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Students")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    router.push(StudentRoute.create)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .refreshable {
            await viewModel.ListStudent()
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Loading students...")
            }
        }
        .onAppear {
            Task {
                await viewModel.ListStudent()
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
        StudentsListView()
    }
}
