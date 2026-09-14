//
//  TeacherAssignmentByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/09/2026.
//

import SwiftUI

struct TeacherAssignmentByIdView: View {
    @State var viewModel = TeacherAssignmentByIdViewModel()
    let assignmentId : Int
    
    @State private var showPdf = false
    
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
