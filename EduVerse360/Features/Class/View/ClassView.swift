//
//  ClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 17/08/2026.
//

import SwiftUI


struct ClassView: View {
    @Environment(NavigationRouter.self) private var router
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
                         error: viewModel.classNameError,
                         text:$viewModel.description,
                         focusedField: $focusedField
            )
            
            Button(
                action:{
                    Task{
                        await viewModel.classes()
                        if viewModel.isclassSuccess{
                            router.goToAllClasses()
                        }
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
    }
}

#Preview {
    ClassView()
}
