//
//  CreateStudentView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 21/09/2026.
//

import SwiftUI

struct CreateStudentView: View {
    @Environment(TabRouter.self) private var router
    @FocusState private var focusedField: Field?
    @State var viewModel = CreateStudentViewModel()
    @State private var dateOfBirth = Date()
    @State private var userIdText = ""
    @State private var showSuccessAlert = false

    private let genders = ["Male", "Female", "Other"]
    private let statuses = ["Active", "Inactive"]

    var body: some View {
        ScrollView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .padding(.bottom, 8)
                }

                AppTextField(title: "User ID",
                             imageName: "",
                             placeholder: "Enter user ID",
                             field: .id,
                             error: nil,
                             text: $userIdText,
                             focusedField: $focusedField
                )

                AppTextField(title: "Admission Number",
                             imageName: "",
                             placeholder: "Enter admission number",
                             field: .admissionNumber,
                             error: nil,
                             text: $viewModel.admissionNumber,
                             focusedField: $focusedField
                )

                AppTextField(title: "Major",
                             imageName: "",
                             placeholder: "Enter major",
                             field: .major,
                             error: nil,
                             text: $viewModel.major,
                             focusedField: $focusedField
                )

                formRow(title: "Enrollment Year") {
                    Text("\(viewModel.enrollmentYear)")
                        .foregroundStyle(.primary)
                    Spacer()
                    Stepper("", value: $viewModel.enrollmentYear, in: 2000...2035)
                        .labelsHidden()
                }

                formRow(title: "Date of Birth") {
                    DatePicker("", selection: $dateOfBirth, displayedComponents: .date)
                        .labelsHidden()
                        .onChange(of: dateOfBirth) {
                            viewModel.dateOfBirth = Self.dateFormatter.string(from: dateOfBirth)
                        }
                }

                formRow(title: "Gender") {
                    Picker("", selection: $viewModel.gender) {
                        ForEach(genders, id: \.self) { gender in
                            Text(gender).tag(gender)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }

                AppTextField(title: "Address",
                             imageName: "",
                             placeholder: "Enter address",
                             field: .address,
                             error: nil,
                             text: $viewModel.address,
                             focusedField: $focusedField
                )

                AppTextField(title: "Guardian Name",
                             imageName: "",
                             placeholder: "Enter guardian name",
                             field: .guardianName,
                             error: nil,
                             text: $viewModel.guardianName,
                             focusedField: $focusedField
                )

                AppTextField(title: "Guardian Phone",
                             imageName: "",
                             placeholder: "Enter guardian phone",
                             field: .guardianPhone,
                             error: nil,
                             text: $viewModel.guardianPhone,
                             focusedField: $focusedField
                )

                formRow(title: "Status") {
                    Picker("", selection: $viewModel.status) {
                        ForEach(statuses, id: \.self) { status in
                            Text(status).tag(status)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }

                Button(
                    action: {
                        guard let userId = Int(userIdText.trimmingCharacters(in: .whitespaces)), userId > 0 else {
                            viewModel.errorMessage = "Please enter a valid User ID"
                            return
                        }
                        viewModel.userId = userId
                        viewModel.errorMessage = nil
                        Task {
                            await viewModel.postStudent()
                            if viewModel.isSuccess {
                                showSuccessAlert = true
                            }
                        }
                    }, label: {
                        Text("Submit")
                            .foregroundColor(Color.white)
                    }
                )
                .frame(maxWidth: 120, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
        .navigationTitle("Create Student")
        .onAppear {
            viewModel.dateOfBirth = Self.dateFormatter.string(from: dateOfBirth)
            if viewModel.enrollmentYear == 0 {
                viewModel.enrollmentYear = Calendar.current.component(.year, from: Date())
            }
        }
        .overlay {
            if viewModel.isLoading {
                LoadingView(message: "Creating student...")
            }
        }
        .alert("Created Successfully", isPresented: $showSuccessAlert) {
            Button("OK") {
                router.pop()
            }
        } message: {
            Text("Student created successfully.")
        }
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private func formRow<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .fontWeight(.semibold)

            HStack {
                content()
            }
            .frame(width: 300, height: 45)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.textFieldColor, lineWidth: 1)
            )
        }
        .frame(width: 300, alignment: .leading)
        .padding(.bottom, 8)
    }
}

#Preview {
    NavigationStack {
        CreateStudentView()
    }
}
