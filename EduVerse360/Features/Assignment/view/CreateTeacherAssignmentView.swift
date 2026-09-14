//
//  CreateAssignmentView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 08/09/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateTeacherAssignmentView: View {
    @State var viewModel = TeacherAssignmentViewModel()
    @Environment(\.dismiss) private var dismiss

    // Controls whether the PDF file picker sheet is on screen.
    @State private var showFileImporter = false

    // DatePicker needs a real Date to work with, but viewModel.dueDate
    // is a String (that's what the API wants). So we keep a Date here
    // for the picker UI, and only convert it to a String when the
    // teacher taps "Done".
    @State private var selectedDueDate = Date()
    @State private var showDatePicker = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                header
                titleField
                descriptionField
                classAndSectionFields
                subjectAndMarksFields
                dueDateField
                attachmentSection
                statusSection
                submitButton
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        // Runs once when the screen first appears — this is what
        // actually calls your two existing API functions so the
        // Class / Section menus below have something to show.
        .task {
            await viewModel.getAllClasses()
            await viewModel.getAllSection()
        }
        .onChange(of: viewModel.isSuccess) { _, success in
            if success { dismiss() }
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.pdf]
        ) { result in
            handleFileImport(result)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.black)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 17)
                .padding(.vertical, 18)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Text("Draft Saved")
                    .foregroundStyle(Color.tertiaryText)
            }
            Spacer().frame(height: 25)

            Text("Teacher")
                .foregroundStyle(Color.primary)
            Text("New Assignment")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
        }
    }

    // MARK: - Title & description

    private var titleField: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .foregroundStyle(Color.secondaryText)
            TextField("Enter assignment title", text: $viewModel.title)
                .padding(.horizontal, 18)
                .padding(.vertical, 20)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var descriptionField: some View {
        VStack(alignment: .leading) {
            Text("Description")
                .foregroundStyle(Color.secondaryText)
                .padding(.top, 16)
            TextEditor(text: $viewModel.description)
                .padding(.horizontal, 18)
                .padding(.vertical, 50)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    // MARK: - Class & Section (now real pickers, not free-typed text)

    private var classAndSectionFields: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                Text("Class")
                    .foregroundStyle(Color.secondaryText)
                Menu {
                    
                    ForEach(Array(viewModel.classes.enumerated()), id: \.offset) { _, classItem in
                        Button(classItem.className) {
                            viewModel.className = classItem.className
                        }
                    }
                } label: {
                    pickerLabel(
                        text: viewModel.className.isEmpty ? "Select" : viewModel.className
                    )
                }
            }
            VStack(alignment: .leading) {
                Text("Section")
                    .foregroundStyle(Color.secondaryText)
                Menu {
                    
                    ForEach(Array(viewModel.listSection.enumerated()), id: \.offset) { _, sectionItem in
                        Button(sectionItem.sectionName) {
                            viewModel.section = sectionItem.sectionName
                        }
                    }
                } label: {
                    pickerLabel(
                        text: viewModel.section.isEmpty ? "Select" : viewModel.section
                    )
                }
            }
        }
        .padding(.top, 16)
    }

    // Small shared piece so both the Class and Section menu buttons
    // look identical to the old TextFields (same padding/background),
    // just with a chevron to hint that it's tappable.
    private func pickerLabel(text: String) -> some View {
        HStack {
            Text(text)
                .foregroundStyle(Color.primary)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundStyle(Color.tertiaryText)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 20)
        .background(Color.inputFields)
        .frame(maxWidth: 180)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Subject & Max Marks

    private var subjectAndMarksFields: some View {
        HStack(spacing: 5) {
            VStack(alignment: .leading) {
                Text("Subject")
                    .foregroundStyle(Color.secondaryText)
                TextField("", text: $viewModel.subject)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                    .background(Color.inputFields)
                    .frame(maxWidth: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            VStack(alignment: .leading) {
                Text("Max Marks")
                    .foregroundStyle(Color.secondaryText)
                // CHANGED: this used to bind to $viewModel.subject by
                // mistake, so typing here was silently overwriting the
                // Subject field. It also needs to end up as an Int, so
                // we bind straight to the Int with a number format
                // instead of going through a String.
                TextField("", value: $viewModel.maxMarks, format: .number)
                    .keyboardType(.numberPad)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                    .background(Color.inputFields)
                    .frame(maxWidth: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(.top, 16)
    }

    // MARK: - Due date (now a real date picker instead of free text)

    private var dueDateField: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Due date")
                .foregroundStyle(Color.secondaryText)
                .padding(.top, 16)

            Button {
                showDatePicker = true
            } label: {
                HStack {
                    Text(viewModel.dueDate.isEmpty ? "Select due date" : displayDueDate)
                        .foregroundStyle(
                            viewModel.dueDate.isEmpty ? Color.tertiaryText : Color.primary
                        )
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundStyle(Color.tertiaryText)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 20)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
        .sheet(isPresented: $showDatePicker) {
            NavigationStack {
                DatePicker("Due date", selection: $selectedDueDate)
                    .datePickerStyle(.graphical)
                    .padding()
                    .navigationTitle("Select due date")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                // This is where the Date becomes the
                                // String your API expects, e.g.
                                // "2026-09-08T23:59:01".
                                viewModel.dueDate = isoString(from: selectedDueDate)
                                showDatePicker = false
                            }
                        }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }

    private func isoString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = .current
        return formatter.string(from: date)
    }

    // Turns the stored ISO string back into something friendlier to
    // read on screen, e.g. "8 Sep 2026, 23:59".
    private var displayDueDate: String {
        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = isoFormatter.date(from: viewModel.dueDate) else {
            return viewModel.dueDate
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "d MMM yyyy, HH:mm"
        return displayFormatter.string(from: date)
    }

    // MARK: - Attachment (now actually opens a file picker)

    private var attachmentSection: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Attachment")
                .foregroundStyle(Color.secondaryText)
                .padding(.top, 16)

            if let fileName = viewModel.attachmentFileName {
                
                HStack(spacing: 13) {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(Color.blue)
                        .frame(width: 40, height: 40)
                        .background(Color.blueTint)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(fileName)
                            .font(.system(size: 14, weight: .medium))
                            .lineLimit(1)
                            .truncationMode(.middle)
                        if let attachmentSize {
                            Text(attachmentSize)
                                .font(.system(size: 12.5))
                                .foregroundStyle(Color.tertiaryText)
                        }
                    }

                    Spacer()

                    Button {
                        viewModel.attachment = nil
                        viewModel.attachmentFileName = nil
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.tertiaryText)
                    }
                }
                .padding(14)
                .background(Color.inputFields)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                // Nothing picked yet — tapping this opens the file picker.
                Button {
                    showFileImporter = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "text.document")
                            .font(.title3)
                            .foregroundStyle(Color.primary)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 18)
                            .background(Color.blueTint)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        Text("Upload attachment (PDF)")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(Color.inputFields)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var attachmentSize: String? {
        guard let data = viewModel.attachment else { return nil }
        return ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
    }

    // Called by .fileImporter above once the user has picked (or
    // cancelled) a file.
    private func handleFileImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            // Files coming from outside your app's own sandbox (like
            // Files or iCloud Drive) require "security scoped" access
            // before you're allowed to read them — this is just how
            // iOS enforces that permission.
            guard url.startAccessingSecurityScopedResource() else {
                viewModel.errorMessage = "Couldn't access that file."
                return
            }
            defer { url.stopAccessingSecurityScopedResource() }

            do {
                let data = try Data(contentsOf: url)
                viewModel.attachment = data
                viewModel.attachmentFileName = url.lastPathComponent
            } catch {
                viewModel.errorMessage = "Couldn't read that file."
            }

        case .failure(let error):
            viewModel.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Status (Draft / Published toggle)

    private var statusSection: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("Status")
                .foregroundStyle(Color.secondaryText)

            HStack {
                statusButton(title: "Draft")
                Spacer()
                statusButton(title: "Published")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.inputFields)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Text(statusHint)
                .foregroundStyle(Color.tertiaryText)
        }
    }

    // CHANGED: both buttons now set the SAME property (selectedFilter)
    // that the rest of the screen reads from, so tapping actually
    // changes what's highlighted and what the submit button says.
    private func statusButton(title: String) -> some View {
        Button(title) {
            viewModel.selectedFilter = title
        }
        .foregroundStyle(viewModel.selectedFilter == title ? .black : .tertiaryText)
        .frame(maxWidth: 200)
        .padding(.vertical, 8)
        .background(viewModel.selectedFilter == title ? Color.white : Color.inputFields)
        .clipShape(Capsule())
    }

    private var statusHint: String {
        if viewModel.selectedFilter == "Draft" {
            return "Saved to your list only. Students see nothing until you publish."
        } else {
            let target = [viewModel.className, viewModel.section]
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            return "Visible to \(target.isEmpty ? "the class" : target) immediately, with a push notification."
        }
    }

    // MARK: - Submit

    private var submitButton: some View {
        Button {
            Task {
                await viewModel.createTeacherAssignment()
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else if viewModel.selectedFilter == "Draft" {
                    Text("Save Draft")
                } else {
                    Text("Publish to \([viewModel.className, viewModel.section].filter { !$0.isEmpty }.joined(separator: " "))")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundStyle(Color.white)
        .padding(.vertical, 20)
        .background(Color.primary)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.top, 20)
        .disabled(viewModel.isLoading)
    }
}

#Preview {
    CreateTeacherAssignmentView()
}
