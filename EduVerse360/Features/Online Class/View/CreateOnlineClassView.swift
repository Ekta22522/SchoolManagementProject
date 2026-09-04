
//
//  CreateOnlineClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 31/08/2026.
//

import SwiftUI

struct CreateOnlineClassView: View {

    @FocusState private var focusedField: Field?

    @State private var viewModel = CreateOnlineClassViewModel()

    var body: some View {

        ZStack {

            // MARK: - Background

            Color.primary
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {

                VStack(spacing: 0) {

                    // MARK: - Header

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Create Online Class")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Set up your class details, timing, and meeting link.")
                            .multilineTextAlignment(.leading)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, 25)
                    .padding(.top, 40)
                    .padding(.bottom, 25)

                    // MARK: - White Section

                    VStack(alignment: .leading, spacing: 0) {

                        Text("Add the details to create your upcoming online session.")
                            .multilineTextAlignment(.leading)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                            .padding(.bottom, 15)

                        // MARK: - Title

                        AppTextField(
                            title: "Title",
                            imageName: "",
                            placeholder: "Enter your title",
                            field: .title,
                            error: viewModel.titleError,
                            text: $viewModel.title,
                            focusedField: $focusedField
                        )

                        // MARK: - Class

                        Text("Class")
                            .font(.caption)
                            .padding(.top, 5)
                            .padding(.bottom, 6)

                        Menu {

                            Button("Grade 1") {
                                viewModel.className = "Grade 1"
                            }

                            Button("Grade 2") {
                                viewModel.className = "Grade 2"
                            }

                            Button("Grade 3") {
                                viewModel.className = "Grade 3"
                            }

                            Button("Grade 4") {
                                viewModel.className = "Grade 4"
                            }

                            Button("Grade 5") {
                                viewModel.className = "Grade 5"
                            }

                            Button("Grade 6") {
                                viewModel.className = "Grade 6"
                            }

                            Button("Grade 7") {
                                viewModel.className = "Grade 7"
                            }

                            Button("Grade 8") {
                                viewModel.className = "Grade 8"
                            }

                        } label: {

                            HStack {

                                Text(
                                    viewModel.className.isEmpty
                                    ? "Select your class"
                                    : viewModel.className
                                )
                                .foregroundColor(
                                    viewModel.className.isEmpty
                                    ? .secondary
                                    : .primary
                                )

                                Spacer()

                                Image("dropdown")
                            }
                            .padding(.horizontal, 12)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 45
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.textFieldColor,
                                        lineWidth: 1
                                    )
                            )
                        }

                        // Class Error

                        if let error = viewModel.classNameError {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }

                        // MARK: - Section

                        Text("Section")
                            .font(.caption)
                            .padding(.top, 10)
                            .padding(.bottom, 6)

                        Menu {

                            Button("Sec A") {
                                viewModel.section = "Sec A"
                            }

                            Button("Sec B") {
                                viewModel.section = "Sec B"
                            }

                            Button("Sec C") {
                                viewModel.section = "Sec C"
                            }

                            Button("Sec D") {
                                viewModel.section = "Sec D"
                            }

                        } label: {

                            HStack {

                                Text(
                                    viewModel.section.isEmpty
                                    ? "Select Your Section"
                                    : viewModel.section
                                )
                                .foregroundColor(
                                    viewModel.section.isEmpty
                                    ? .secondary
                                    : .primary
                                )

                                Spacer()

                                Image("dropdown")
                            }
                            .padding(.horizontal, 12)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 45
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.textFieldColor,
                                        lineWidth: 1
                                    )
                            )
                        }

                        // Section Error

                        if let error = viewModel.sectionError {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }

                        // MARK: - Subject

                        Text("Subject")
                            .font(.caption)
                            .padding(.top, 10)
                            .padding(.bottom, 6)

                        Menu {

                            Button("Science") {
                                viewModel.subject = "Science"
                            }

                            Button("Math") {
                                viewModel.subject = "Math"
                            }

                            Button("Social Studies") {
                                viewModel.subject = "Social Studies"
                            }

                            Button("English") {
                                viewModel.subject = "English"
                            }

                        } label: {

                            HStack {

                                Text(
                                    viewModel.subject.isEmpty
                                    ? "Select your Subject"
                                    : viewModel.subject
                                )
                                .foregroundColor(
                                    viewModel.subject.isEmpty
                                    ? .secondary
                                    : .primary
                                )

                                Spacer()

                                Image("dropdown")
                            }
                            .padding(.horizontal, 12)
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 45
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.textFieldColor,
                                        lineWidth: 1
                                    )
                            )
                        }

                        // Subject Error

                        if let error = viewModel.subjectError {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }

                        // MARK: - Description

                        AppTextField(
                            title: "Description",
                            imageName: "",
                            placeholder: "Enter your description",
                            field: .description,
                            error: viewModel.descriptionError,
                            text: $viewModel.description,
                            focusedField: $focusedField
                        )
                        .padding(.top, 5)

                        // MARK: - Meeting URL

                        AppTextField(
                            title: "Meeting URL",
                            imageName: "",
                            placeholder: "https://example.com",
                            field: .meetingUrl,
                            error: viewModel.meetingUrlError,
                            text: $viewModel.meetingUrl,
                            focusedField: $focusedField
                        )
                        .padding(.top, 5)

                        // MARK: - Schedule

                        HStack(
                            alignment: .top,
                            spacing: 10
                        ) {

                            // MARK: Date

                            VStack(
                                alignment: .leading,
                                spacing: 8
                            ) {

                                Text("Schedule")
                                    .font(.caption)

                                DatePicker(
                                    "",
                                    selection: $viewModel.scheduledDate,
                                    displayedComponents: .date
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            }

                            // MARK: Time

                            VStack(
                                alignment: .leading,
                                spacing: 8
                            ) {

                                Text("Time")
                                    .font(.caption)

                                DatePicker(
                                    "",
                                    selection: $viewModel.scheduledDate,
                                    displayedComponents: .hourAndMinute
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            }

                            // MARK: Duration

                            VStack(
                                alignment: .leading,
                                spacing: 8
                            ) {

                                Text("Duration")
                                    .font(.caption)

                                Picker(
                                    "Duration",
                                    selection: $viewModel.durationMinutes
                                ) {

                                    ForEach(
                                        viewModel.durationOptions,
                                        id: \.self
                                    ) { duration in

                                        Text("\(duration) minutes")
                                            .tag(duration)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding(.top, 15)

                        // Schedule Error

                        if let error = viewModel.scheduledAtError {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }

                        // Duration Error

                        if let error = viewModel.durationMinutesError {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }

                        // MARK: - Server Error

                        if let error = viewModel.errorMessage {

                            HStack(
                                alignment: .top,
                                spacing: 8
                            ) {

                                Image(systemName: "exclamationmark.circle.fill")

                                Text(error)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                            }
                            .foregroundColor(.red)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .padding(.top, 15)
                        }

                        // MARK: - Create Button

                        Button {

                            Task {
                                await viewModel.createOnlineClass()
                            }

                        } label: {

                            HStack {

                                if viewModel.isLoading {

                                    ProgressView()
                                        .tint(.white)

                                    Text("Creating...")
                                        .foregroundColor(.white)

                                } else {

                                    Text("Create Class")
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(
                                maxWidth: .infinity,
                                minHeight: 50
                            )
                            .background(Color.primary)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.isLoading)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        if let error = viewModel.errorMessage {

                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding(.top, 4)
                        }


                        Spacer()
                    }
                    .padding(.horizontal, 25)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 600,
                        alignment: .top
                    )
                    .background(
                        Color.white
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 40,
                                    style: .continuous
                                )
                            )
                    )
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    CreateOnlineClassView()
}

