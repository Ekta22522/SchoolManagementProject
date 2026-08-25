//
//  UpdateClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import SwiftUI

struct UpdateClassView: View {
    
    let classId : String
    
    @State var viewModel = UpdateClassViewModel()
    @FocusState private var focusedField : Field?
    
    @Environment(NavigationRouter.self) private var router
    
    
    
    var body: some View {
        VStack{
            AppTextField(title:"Class Name",
                         imageName: "",
                         placeholder: "Enter your Class name",
                         field:.className,
                         error: viewModel.classNameError,
                         text:$viewModel.className,
                         focusedField: $focusedField
            )
            
            AppTextField(title:"Description",
                         imageName: "",
                         placeholder: "Enter Description",
                         field:.description,
                         error: viewModel.classNameError,
                         text:$viewModel.description,
                         focusedField: $focusedField
            )
            
            Button(
                action:{
                    Task{
                        await viewModel.updateClass(id: classId)
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
        .alert(
            "Success",
            isPresented: $viewModel.isUpdateClass
        ) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text("Class with id: \(classId) is updated successfully")
        }
        .task {
            await viewModel.getClassById(id: classId)
        }
    }
}

#Preview {
    UpdateClassView(classId: "")
}
