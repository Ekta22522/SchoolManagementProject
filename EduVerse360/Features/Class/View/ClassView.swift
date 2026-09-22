//
//  ClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import SwiftUI


struct ClassView: View {
    @Environment(TabRouter.self) private var router
    @FocusState private var focusedField : Field?
    @State var viewModel = ClassViewModel()
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
                         error: viewModel.descriptionError,
                         text:$viewModel.description,
                         focusedField: $focusedField
            )
            
            Button(
                action:{
                    Task{
                        await viewModel.classes()
                    }
                },label:{
                    Text("Submit")
                        .foregroundColor(Color.white)
                }
            )
            .frame(maxWidth:120,maxHeight: 50)
            .background(Color.primary)
            .cornerRadius(10)
            
        }
        .alert(
            "Success",
            isPresented: $viewModel.isclassSuccess
        ) {
            Button("OK", role: .cancel) {
                router.pop()
            }
        } message: {
            Text("Class created successfully.")
        }
    }
}

#Preview {
    ClassView()
}
