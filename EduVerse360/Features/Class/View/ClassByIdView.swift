//
//  ClassByIdView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 18/08/2026.
//

import SwiftUI

struct ClassByIdView: View {
  
    @State var viewModel = ClassByIdViewModel()
    @Environment(NavigationRouter.self) private var router
    
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
                    router.goToUpdateClass(id: classId)
                },label:{
                    Text("Update")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                
                
                Button(action:{
                    router.goToDeleteClass(id: classId)
                },label:{
                    Text("Delete")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:100, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
                
                Button(action:{
                    router.goToCreateSection(id:classId)
                },label:{
                    Text("Add Section")
                        .foregroundStyle(.white)
                })
                .frame(maxWidth:120, maxHeight: 50)
                .background(Color.primary)
                .cornerRadius(10)
            }
            
        }
        .task {
            await viewModel.getClassesById(id: classId)
        }
        
        
    }
}

#Preview {
    ClassByIdView(classId: "")
}
