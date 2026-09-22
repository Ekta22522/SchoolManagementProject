//
//  UpdateOnlineClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 02/09/2026.
//

import SwiftUI

struct UpdateOnlineClassView: View {
    @FocusState private var focusedField: Field?
    @State var viewModel = UpdateOnlineClassViewModel()
    @Environment(TabRouter.self) private var router
    let onlineClassId : Int

    // API-driven options for the Class and Section menus, fetched on appear.
    @State private var allClassesViewModel = AllClassesViewModel()
    @State private var listSectionViewModel = ListSectionViewModel()

    // Tracks the first load so we can show a spinner instead of empty fields.
    @State private var isInitialLoadComplete = false

    var body: some View {

        ZStack {

            // MARK: - Background

            Color.primary
                .ignoresSafeArea()

            if isInitialLoadComplete {

                ScrollView(.vertical, showsIndicators: false) {

                    VStack(spacing: 0) {

                        // MARK: - Header

                        VStack(alignment: .leading, spacing: 8) {

                            Text("Update Online Class")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Update your class details, timing, and meeting link.")
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

                            Text("Update the details to modify your online session.")
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

                                ForEach(allClassesViewModel.classes) { classItem in
                                    Button(classItem.className) {
                                        viewModel.className = classItem.className
                                    }
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

                                ForEach(listSectionViewModel.listSection ?? []) { sectionItem in
                                    Button(sectionItem.sectionName) {
                                        viewModel.section = sectionItem.sectionName
                                    }
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

                            AppTextField(
                                title: "Subject",
                                imageName: "",
                                placeholder: "Enter your subject",
                                field: .subject,
                                error: viewModel.subjectError,
                                text: $viewModel.subject,
                                focusedField: $focusedField
                            )
                            .padding(.top, 5)

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

                            // MARK: - Update Button

                            Button {

                                Task {
                                    await viewModel.getUpdateOnlineClass(id: onlineClassId)
                                }

                            } label: {

                                HStack {

                                    if viewModel.isLoading {

                                        ProgressView()
                                            .tint(.white)

                                        Text("Updating...")
                                            .foregroundColor(.white)

                                    } else {

                                        Text("Update Class")
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

            } else {

                // MARK: - Initial Loading

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
        }
        .task {
            await viewModel.getOnlineClassId(id: onlineClassId)
            await allClassesViewModel.getAllClasses()
            await listSectionViewModel.getAllSection()
            isInitialLoadComplete = true
        }
        .alert(
            "Updated Successfully",
            isPresented: $viewModel.isSuccess
        ) {
            Button("OK") {
                router.pop()
            }
        } message: {
            Text("The online class was updated successfully.")
        }
    }
}

#Preview {
    UpdateOnlineClassView(onlineClassId: 0)
}
