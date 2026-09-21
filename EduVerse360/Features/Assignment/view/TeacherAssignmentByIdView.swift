//
//  TeacherAssignmentByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/09/2026.
//

import SwiftUI

struct TeacherAssignmentByIdView: View {
    @State var viewModel = TeacherAssignmentByIdViewModel()
    @State private var deleteViewModel = DeleteTeacherAssignmentViewModel()
    @State private var showDeleteConfirmation = false
    let assignmentId : Int
   
    @Environment(TabRouter.self) private var router
    @Environment(UserSession.self) private var session

    @State private var showPdf = false
    @State private var hasAppeared = false
    
    var body: some View {
        ZStack{
            Color.pageBackground
                .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(Color.secondaryText)
            } else if let assignment = viewModel.assignment {
                ScrollView{
                    VStack(alignment:.leading,spacing: 16){
                        
                        // MARK: Header
                        VStack(alignment:.leading,spacing: 8){
                            Text(assignment.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(assignment.subject)
                                .foregroundStyle(Color.tertiaryText)
                        }
                        
                        HStack {
                            Text(assignment.status)
                                .foregroundStyle(Color.teal)
                                .padding(.horizontal,16)
                                .padding(.vertical,8)
                                .background(Color.tealTint)
                                .clipShape(Capsule())
                            Spacer()
                        }
                        
                        // MARK: Details
                        VStack(alignment:.leading,spacing: 14){
                            sectionTitle("Details")
                            detailRow(label: "Class", value: assignment.className)
                            detailRow(label: "Section", value: assignment.section)
                            detailRow(label: "Subject", value: assignment.subject)
                            detailRow(label: "Due date", value: formatDueDate(assignment.dueDate))
                            detailRow(label: "Max marks", value: "\(assignment.maxMarks)")
                            detailRow(label: "Created", value: formatDueDate(assignment.createdAt))
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        
                        // MARK: Description
                        VStack(alignment:.leading,spacing: 8){
                            sectionTitle("Description")
                            Text(assignment.description)
                                .foregroundStyle(Color.secondaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        
                        // MARK: Attachment
                        if let fileName = assignment.attachmentOriginalName {
                            VStack(alignment:.leading,spacing: 8){
                                sectionTitle("Attachment")
                                HStack {
                                    Image(systemName: "paperclip")
                                    Text(fileName)
                                        .lineLimit(1)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color.tertiaryText)
                                }
                                .foregroundStyle(Color.secondaryText)
                                .padding(.horizontal,14)
                                .padding(.vertical,16)
                                .background(Color.inputFields)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .onTapGesture{ showPdf = true }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                        }

                        // MARK: Update
                        if session.activeRole != .student {
                            Button {
                                router.push(AssignmentRoute.update(id: assignmentId))
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
                                        Text("Delete Assignment")
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
                    }
                    .padding()
                }
                .sheet(isPresented: $showPdf) {
                    PDFScreen(pdfURL: assignment.attachmentUrl ?? "")
                }
            }
        }
        .task {
            await viewModel.TeacherAssignmentById(id: assignmentId)
        }
        // When the teacher returns from the update screen the first
        // .task has already run, so refetch here to show edited values.
        .onAppear {
            if hasAppeared {
                Task {
                    await viewModel.TeacherAssignmentById(id: assignmentId)
                }
            }
            hasAppeared = true
        }
        // Ask before deleting — destructive, so the teacher has to confirm.
        .alert(
            "Delete Assignment?",
            isPresented: $showDeleteConfirmation
        ) {
            Button("Delete", role: .destructive) {
                Task {
                    await deleteViewModel.deleteTeacherAssignment(id: assignmentId)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this assignment? This action cannot be undone.")
        }
        // Delete succeeded — show confirmation, then go back to the
        // assignments list, which refetches on reappear so the
        // deleted card disappears.
        .alert(
            "Deleted Successfully",
            isPresented: Binding(
                get: { deleteViewModel.isSuccess },
                set: { if !$0 { deleteViewModel.isSuccess = false } }
            )
        ) {
            Button("OK") { router.pop() }
        } message: {
            Text("The assignment was deleted successfully.")
        }
        // Delete failed — surface the API error so the teacher isn't
        // left wondering why nothing happened.
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
}

#Preview {
    TeacherAssignmentByIdView(
        assignmentId: 1
    )
}
