//
//  ClassByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 18/08/2026.
//

import SwiftUI

struct ClassByIdView: View {

    @State var viewModel = ClassByIdViewModel()
    @State private var deleteViewModel = DeleteClassViewModel()
    @State private var showDeleteConfirmation = false
    @Environment(TabRouter.self) private var router

    var classId: String


    var body: some View {

        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            if viewModel.isLoading && viewModel.classroom == nil {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.classroom == nil {
                Text(errorMessage)
                    .foregroundStyle(Color.secondaryText)
            } else if let classroom = viewModel.classroom {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // MARK: Header

                        VStack(alignment: .leading, spacing: 8) {
                            Text(classroom.className)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text("Class details and sections")
                                .font(.subheadline)
                                .foregroundStyle(Color.tertiaryText)
                        }

                        // MARK: Details

                        VStack(alignment: .leading, spacing: 14) {
                            sectionTitle("Details")
                            detailRow(label: "Class ID", value: classroom.id)
                            detailRow(label: "Sections", value: "\(classroom.sectionCount ?? 0)")
                            detailRow(label: "Capacity", value: classroom.totalCapacity.map { "\($0)" } ?? "—")
                            detailRow(label: "Created", value: formatDate(classroom.createdAt))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)

                        // MARK: Description

                        if !classroom.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                sectionTitle("Description")
                                Text(classroom.description)
                                    .foregroundStyle(Color.secondaryText)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        }

                        // MARK: Sections

                        VStack(alignment: .leading, spacing: 8) {
                            sectionTitle("Sections")

                            sectionLink(title: "Class Sections", icon: "rectangle.split.3x1") {
                                router.push(SectionRoute.classSections(classId: classId))
                            }

                            sectionLink(title: "All Sections", icon: "square.stack.3d.up") {
                                router.push(SectionRoute.list)
                            }

                            Button {
                                router.push(SectionRoute.create(classId: classId))
                            } label: {
                                Text("Add Section")
                                    .foregroundStyle(Color.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primary)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.top, 4)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)

                        // MARK: Update

                        Button {
                            router.push(ClassRoute.update(id: classId))
                        } label: {
                            Text("Update")
                                .foregroundStyle(Color.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.top, 8)

                        // MARK: Delete

                        Button {
                            showDeleteConfirmation = true
                        } label: {
                            Group {
                                if deleteViewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Delete Class")
                                }
                            }
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        .disabled(deleteViewModel.isLoading)
                        .padding(.top, 8)
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.getClassesById(id: classId)
            await deleteViewModel.getClassById(id: classId)
        }
        .confirmationDialog("Delete this class?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await deleteViewModel.deleteClass(id: classId) }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Class deleted", isPresented: $deleteViewModel.isDeleteClass) {
            Button("OK") { router.pop() }
        }
        .alert(
            "Couldn't Delete",
            isPresented: Binding(
                get: { deleteViewModel.errorMessage != nil },
                set: { if !$0 { deleteViewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(deleteViewModel.errorMessage ?? "")
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(Color.tertiaryText)
            Spacer()
            Text(value)
                .foregroundStyle(Color.secondaryText)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }

    private func sectionLink(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(Color.tertiaryText)
            }
            .foregroundStyle(Color.secondaryText)
            .padding(.horizontal, 14)
            .padding(.vertical, 16)
            .background(Color.inputFields)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func formatDate(_ createdAt: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoFormatter.date(from: createdAt) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }

        isoFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoFormatter.date(from: createdAt) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }

        return createdAt
    }
}

#Preview {
    ClassByIdView(classId: "")
        .environment(TabRouter())
}
