//
//  StudentDetailView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 28/07/2026.
//

import SwiftUI

struct StudentDetailView: View {
    
    let studentId : Int
    
    @State private var viewModel = StudentDetailsViewModel(studentService: StudentMockAPI())
    
    var body: some View {
        
        
        VStack{
            if let std =  viewModel.student {
                VStack(){
                    Text("Student Details")
                        .font(.largeTitle)
                    Text("\(std.id)")
//                    Text("\(std.firstName)")
                    
                }
                .foregroundColor(Color.primary)
                
            }else{
                Text("Nil")
            }
            
        } .task {
                await viewModel.loadStudentDetail(by: studentId)
            }
    }
}

#Preview {
    StudentDetailView(studentId: 1)
}
