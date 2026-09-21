//
//  UpdateStudentView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import SwiftUI

struct UpdateStudentView: View {

    let student: Student

    @Environment(TabRouter.self) private var router
    @FocusState private var focusedField: Field?
    @State var viewModel = UpdateStudentViewModel()
    @State private var dateOfBirth = Date()
    @State private var showSuccessAlert = false

    private let genders = ["Male", "Female", "Other"]
    private let statuses = ["Active", "Inactive"]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(12)
                }

                profileHeader

                sectionCard(title: "Academic Details", icon: "book.fill") {
                    FormField(title: "Admission Number", placeholder: "Enter admission number", field: .admissionNumber, text: $viewModel.admissionNumber, focusedField: $focusedField)

                    FormField(title: "Major", placeholder: "Enter major", field: .major, text: $viewModel.major, focusedField: $focusedField)

                    stepperRow(title: "Enrollment Year", value: $viewModel.enrollmentYear)

                    pickerRow(title: "Status", selection: $viewModel.status, options: statuses)

                    Toggle("Alumni", isOn: $viewModel.isAlumni)
                        .font(.subheadline)
                        .foregroundStyle(Color.secondaryText)
                        .tint(Color.primary)
                }

                sectionCard(title: "Personal Details", icon: "person.fill") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Date of Birth")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.secondaryText)

                        DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.inputFields)
                            .cornerRadius(10)
                            .onChange(of: dateOfBirth) {
                                viewModel.dateOfBirth = Self.dateFormatter.string(from: dateOfBirth)
                            }
                    }

                    pickerRow(title: "Gender", selection: $viewModel.gender, options: genders)

                    FormField(title: "Address", placeholder: "Enter address", field: .address, text: $viewModel.address, focusedField: $focusedField)
                }

                sectionCard(title: "Guardian Details", icon: "person.2.fill") {
                    FormField(title: "Guardian Name", placeholder: "Enter guardian name", field: .guardianName, text: $viewModel.guardianName, focusedField: $focusedField)

                    FormField(title: "Guardian Phone", placeholder: "Enter guardian phone", field: .guardianPhone, text: $viewModel.guardianPhone, focusedField: $focusedField)
                }

                Button {
                    submitUpdate()
                } label: {
                    Text("Update Student")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.primary)
                        .cornerRadius(12)
                        .shadow(color: Color.primary.opacity(0.3), radius: 6, y: 3)
                }
                .padding(.top, 4)
            }
            .padding()
        }
        .background(Color.pageBackground.ignoresSafeArea())
        .navigationTitle("Update Student")
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            prefillForm()
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Updating student...")
            }
        }
        .alert("Updated Successfully", isPresented: $showSuccessAlert) {
            Button("OK") {
                router.pop()
            }
        } message: {
            Text("Student updated successfully.")
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color.teal.opacity(0.15))
                .frame(width: 64, height: 64)
                .overlay {
                    Text(initials(for: student.userName))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.teal)
                }

            Text(student.userName ?? "N/A")
                .font(.headline)
                .foregroundStyle(Color.secondaryText)

            Text(student.email ?? "N/A")
                .font(.caption)
                .foregroundStyle(Color.tertiaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color.white)
        .cornerRadius(16)
    }

    private func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
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

    private func stepperRow(title: String, value: Binding<Int>) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)

            Spacer()

            Text("\(value.wrappedValue)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
                .frame(minWidth: 48)

            Stepper("", value: value, in: 2000...2035)
                .labelsHidden()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.inputFields)
        .cornerRadius(10)
    }

    private func pickerRow(title: String, selection: Binding<String>, options: [String]) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryText)

            Spacer()

            Picker("", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .tint(Color.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color.inputFields)
        .cornerRadius(10)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private func prefillForm() {
        viewModel.userId = student.userId
        viewModel.admissionNumber = student.admissionNumber
        viewModel.enrollmentYear = student.enrollmentYear
        viewModel.major = student.major
        viewModel.dateOfBirth = student.dateOfBirth
        viewModel.gender = student.gender
        viewModel.address = student.address
        viewModel.guardianName = student.guardianName
        viewModel.guardianPhone = student.guardianPhone
        viewModel.status = student.status
        viewModel.isAlumni = student.isAlumni

        if let parsedDate = Self.dateFormatter.date(from: student.dateOfBirth) {
            dateOfBirth = parsedDate
        }
    }

    private func submitUpdate() {
        let request = UpdateStudentReq(userId: viewModel.userId,
                                       admissionNumber: viewModel.admissionNumber,
                                       enrollmentYear: viewModel.enrollmentYear,
                                       major: viewModel.major,
                                       dateOfBirth: viewModel.dateOfBirth,
                                       gender: viewModel.gender,
                                       address: viewModel.address,
                                       guardianName: viewModel.guardianName,
                                       guardianPhone: viewModel.guardianPhone,
                                       status: viewModel.status,
                                       isAlumni: viewModel.isAlumni)
        Task {
            await viewModel.putStudent(req: request, id: student.id)
            if viewModel.isSuccess {
                showSuccessAlert = true
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

private struct FormField: View {
    let title: String
    let placeholder: String
    let field: Field
    @Binding var text: String
    @FocusState.Binding var focusedField: Field?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(Color.secondaryText)

            TextField(placeholder, text: $text)
                .font(.subheadline)
                .focused($focusedField, equals: field)
                .submitLabel(.next)
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
                .background(Color.inputFields)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(focusedField == field ? Color.primary : Color.clear, lineWidth: 1.5)
                )
        }
    }
}

#Preview {
    NavigationStack {
        UpdateStudentView(student: Student(id: 1,
                                           userId: 1,
                                           userName: "John Doe",
                                           email: "john@example.com",
                                           role: "student",
                                           admissionNumber: "ADM001",
                                           enrollmentYear: 2024,
                                           major: "Science",
                                           dateOfBirth: "2005-01-01",
                                           gender: "Male",
                                           address: "123 Street",
                                           guardianName: "Jane Doe",
                                           guardianPhone: "555-0100",
                                           status: "Active",
                                           isAlumni: false,
                                           createdAt: "",
                                           updatedAt: ""))
    }
}
