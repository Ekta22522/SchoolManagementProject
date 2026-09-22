//
//  SectionByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

import SwiftUI

struct SectionByIdView: View {
    @Environment(TabRouter.self) private var router
    @State var viewModel = SectionByIdViewModel()
    @State private var deleteViewModel = DeleteSectionViewModel()
    @State private var showDeleteConfirmation = false

    var sectionId : Int
    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            if viewModel.isLoading && viewModel.section == nil {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage, viewModel.section == nil {
                Text(errorMessage)
                    .foregroundStyle(Color.secondaryText)
            } else if let section = viewModel.section {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // MARK: Header

                        VStack(alignment: .leading, spacing: 8) {
                            Text(section.sectionName)
                                .font(.largeTitle)
                                .fontWeight(.bold)

                            Text(section.className ?? "Section details")
                                .font(.subheadline)
                                .foregroundStyle(Color.tertiaryText)
                        }

                        // MARK: Details

                        VStack(alignment: .leading, spacing: 14) {
                            sectionTitle("Details")
                            detailRow(label: "Section ID", value: "\(section.id)")
                            detailRow(label: "Class", value: section.className ?? "—")
                            detailRow(label: "Class Teacher", value: section.classTeacher)
                            detailRow(label: "Capacity", value: "\(section.capacity)")
                            detailRow(label: "Created", value: formatDate(section.createdAt))
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

                        // MARK: Update

                        Button {
                            router.push(SectionRoute.update(id: sectionId))
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
                                    Text("Delete Section")
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
            await viewModel.section(id: sectionId)
        }
        .confirmationDialog("Delete this section?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task { await deleteViewModel.deleteSection(id: sectionId) }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Section deleted", isPresented: $deleteViewModel.isDeleteSuccess) {
            Button("OK") { router.pop() }
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
    SectionByIdView(sectionId:1)
        .environment(TabRouter())
}
