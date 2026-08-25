//
//  UpdateSectionView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 24/08/2026.
//

import SwiftUI

struct UpdateSectionView: View {
    var sectionId : Int
    @State var viewModel = UpdateSectionViewModel()
    @Environment(NavigationRouter.self)private  var router
    @FocusState private var focusedField : Field?
    var body: some View {
        VStack{
            if let section = viewModel.section{
                VStack{
                    Text("hello world")
                    Text("SectionID: \(section.id)")
                    Text("ClassID: \(section.classId)")
                    AppTextField(title:"Section Name",
                                 imageName: "",
                                 placeholder: "Enter your Section",
                                 field:.description,
                                 error:viewModel.classNameError,
                                 text:$viewModel.sectionName,
                                 focusedField: $focusedField
                    )
                    
                    AppTextField(title:"Class Teacher",
                                 imageName: "",
                                 placeholder: "Enter your teacher name",
                                 field:.description,
                                 error:viewModel.classNameError,
                                 text:$viewModel.classTeacher,
                                 focusedField: $focusedField
                    )
                  
                    Button(
                        action:{
                            Task{
                                await viewModel.updateSection(id: sectionId)
                            }
                        },label:{
                            Text("Update")
                                .foregroundColor(Color.white)
                        }
                    )
                    .frame(maxWidth:120,maxHeight: 50)
                    .background(Color.primary)
                    .cornerRadius(10)
                    
                }
            }
            
            
        }
        .alert(
            "Success",
            isPresented: $viewModel.isUpdateSuccess
        ) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text("Section with id: \(sectionId) is updated successfully")
        }
        .task {
            await viewModel.getSectionById(id: sectionId)
        }
    }
}

#Preview {
    UpdateSectionView(sectionId: 0)
}
