//
//  Section.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

import SwiftUI

struct SectionView: View {
    @Environment(NavigationRouter.self) private var router
    @FocusState private var focusedField : Field?
    @State var viewModel = SectionViewModel()
    
    let classId : String
    var body: some View {
       VStack {
           Text("Class ID:\(classId)")
            
            AppTextField(title:"Section Name",
                         imageName: "",
                         placeholder: "Enter Your Section",
                         field:.sectionName,
                         error: viewModel.error,
                         text:$viewModel.sectionName,
                         focusedField: $focusedField)
                         
            AppTextField(title:"Teacher Name",
                                      imageName: "",
                                      placeholder: "Enter teacher name ",
                         field:.classTeacher,
                                      error: viewModel.error,
                                    text:$viewModel.classTeacher,
                                      focusedField: $focusedField
                         )
                         
                         AppTextField(title:"Capacity",
                                      imageName: "",
                                      placeholder: "Enter number",
                                      field:.capacity,
                                      error: viewModel.error,
                                      text:$viewModel.capacity,
                                      focusedField: $focusedField
            )
            
            Button(
                action:{
                    Task{
                        await viewModel.postSection(id: classId)
                        
                    }
                },label:{
                    Text("Add")
                        .foregroundColor(Color.white)
                }
            )
            .frame(maxWidth:120,maxHeight: 50)
            .background(Color.primary)
            .cornerRadius(10)
            
        }
       .onAppear{
           viewModel.getclassId(Id: classId)
       }
    }
}

#Preview {
    SectionView(classId: "")
}
