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
        VStack{
            VStack{
                if let section = viewModel.section{
                    Text("Section Id:\(section.id)")
                    Text("Class Id:\(section.classId)")
                    if let classname = section.className{
                        Text("Class Name:\(classname)")
                    }
                    Text("Section Name:\(section.sectionName)")
                    Text("Class Teacher:\(section.classTeacher)")
                    Text("Capacity:\(section.capacity)")
                    Text("Created At:\(section.createdAt)")
                }
            }
            .foregroundColor(Color.white)
            .background(Color.primary)
            .cornerRadius(20)
            .shadow(radius: 10)
            HStack{
                Button(action:{
                    router.push(SectionRoute.update(id: sectionId))
                },label:{
                    Text("Update")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                
                Button(action:{
                    showDeleteConfirmation = true
                },label:{
                    Text("Delete")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
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
}

#Preview {
    SectionByIdView(sectionId:1)
}
