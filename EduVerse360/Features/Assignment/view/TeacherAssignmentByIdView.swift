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
    var body: some View {
        VStack{
        
            
        }
        .task {
            await viewModel.TeacherAssignmentById(id: assignmentId)
        }
        
    }
}

#Preview {
    TeacherAssignmentByIdView(
        assignmentId: 1
    )
}
