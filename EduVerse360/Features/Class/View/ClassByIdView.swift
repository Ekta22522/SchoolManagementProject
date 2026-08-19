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
            
            Button(action:{
                
            },label:{
                Text("Update Class")
            })
            
        }
        .task {
            await viewModel.getClassesById(id: classId)
        }
        
        
    }
}

#Preview {
    ClassByIdView(classId: "")
}
