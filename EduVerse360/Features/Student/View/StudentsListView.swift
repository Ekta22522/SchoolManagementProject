//
//  StudentsListView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import SwiftUI

struct StudentsListView: View {
    @Environment(NavigationRouter.self) private var router

    @State private var viewModel = StudentListViewModel(
        studentService: StudentMockAPI()
    )

    var body: some View {

        NavigationStack {
            
            
            VStack{
                if viewModel.students.isEmpty{
                    Text("Student not Available")
                        .foregroundColor(Color.secondaryText)
                }else{
                    
                    List(viewModel.students) { student in
                        
                        VStack(alignment: .leading) {
                            
//                            Text("\(student.firstName) \(student.lastName)")
//                                .font(.headline)
//                                .foregroundColor(Color.primary)
                            
                            Text(student.email)
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            router.goToStudentDetail(id: student.id)
                        }
                        
                    }
                    
                    
                }
                
                
                HStack{
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.secondaryText)
                    TextField("search...", text: $viewModel.searchText)
                    if !viewModel.searchText.isEmpty {
                        
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                    
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
            }
            .navigationTitle("Students")
            .task {
                await viewModel.loadStudents()
            }
            .onChange(of: viewModel.searchText){
                Task{
                    await viewModel.searchStudent()
                }
            }
            
            
        }
        
    }
}

#Preview {
    StudentsListView()
}
