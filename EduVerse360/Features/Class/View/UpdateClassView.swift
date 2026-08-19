//
//  UpdateClassView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 19/08/2026.
//

import SwiftUI

struct UpdateClassView: View {
    @State var viewModel = UpdateViewModel()
    @FocusState private var focusedField : Field?
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
                       await viewModel.updateClassById()
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

#Preview {
    UpdateClassView()
}
