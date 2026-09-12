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
        
        VStack(spacing: 10) {
            
            if let classroom = viewModel.classroom {
                VStack {
                    Text("Class ID: \(classroom.id)")
                    Text("Class Name: \(classroom.className)")
                    Text("Class Detail: \(classroom.description)")
                }
            }
            HStack(spacing:50){
                Button(action:{
                    router.push(ClassRoute.update(id: classId))
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
                
                Button(action:{
                    router.push(SectionRoute.create(classId: classId))
                },label:{
                    Text("Add Section")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:120, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
            }
            VStack(spacing:10){
                Button(action:{
                    router.push(SectionRoute.list)
                },label:{
                    Text("All Section")
                        .foregroundStyle(.white)
                        .padding()
                })
                .frame(maxWidth:120, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                
                Button(action:{
                    router.push(SectionRoute.classSections(classId: classId))
                },label:{
                    Text("class all Section")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
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
        
        
    }
}

#Preview {
    ClassByIdView(classId: "")
}
