//
//  TeacherDetailView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 28/07/2026.
//

import SwiftUI

struct TeacherDetailView: View {
    
    let teacherId : Int
   
    
    @State private var viewModel = TeacherDetailViewModel(teacherService: TeacherMockAPI())
    
    var body: some View {
       
            VStack{
                if let tchr = viewModel.teacher{
                    Text("Id: \(tchr.id)")
//                    Text("Name:\(tchr.firstName)\(tchr.lastName)")
                    Text("Email:\(tchr.email)")
                    Text("Role:\(tchr.role)")
                }else{
                    Text("....")
                    
                }
            }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.primary)
            .task {
                print("Loading teacher with id:", teacherId)
                await viewModel.loadTeacherDetail(by: teacherId)
            }.navigationTitle("Teacher List")
        
    }
}
#Preview {
    TeacherDetailView(teacherId: 3)
}
