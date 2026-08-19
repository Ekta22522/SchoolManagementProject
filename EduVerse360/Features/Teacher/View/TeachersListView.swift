//
//  TeachersLIst.swift
//  EduVerse360
//
//  Created by Ekta Rai on 27/07/2026.
//

import SwiftUI

struct TeachersListView: View {
    @Environment(NavigationRouter.self) private var router
   
    @State var viewModel = TeachersListViewModel(
        teacherService: TeacherMockAPI()
    )
  
    var body: some View {
        
        NavigationStack {
            
            
            VStack{
                
            
                if viewModel.teachers.isEmpty {
                    
                    Text("Teacher not available")
                    
                }else{
                    
                    List(viewModel.teachers) { teacher in
                        
                        VStack(alignment: .leading) {
//                            
//                            Text("\(teacher.firstName) \(teacher.lastName)")
//                                .font(.headline)
//                                .foregroundColor(Color.primary)
                            
                            Text(teacher.email)
                                .foregroundStyle(.secondary)
                        }
                        .onTapGesture {
                            router.goToTeacherDetail(id: teacher.id)
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
            .navigationTitle("Teachers")
            .task {
                await viewModel.loadTeachers()
            }
            .onChange(of: viewModel.searchText) {
                Task {
                    await viewModel.searchTeachers()
                }
            }
            
          
        }
    }
}
    #Preview {
        TeachersListView()
    }


