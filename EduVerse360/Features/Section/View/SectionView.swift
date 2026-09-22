//
//  SectionView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 20/08/2026.
//

import SwiftUI

struct SectionView: View {
    @Environment(TabRouter.self) private var router
    @FocusState private var focusedField : Field?
    @State var viewModel = SectionViewModel()

    let classId : String
    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // MARK: Header

                    Text("Create Section")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // MARK: Form

                    VStack(spacing: 4) {
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
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 3)

                    // MARK: Submit

                    Button(
                        action:{
                            Task{
                                await viewModel.postSection(id: classId)

                            }
                        },label:{
                            Group {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Add Section")
                                }
                            }
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    )
                    .disabled(viewModel.isLoading)
                }
                .padding()
            }
        }
       .onAppear{
           viewModel.getclassId(Id: classId)
       }
       .alert(
           "Success",
           isPresented: $viewModel.isSectionSuccess
       ) {
           Button("OK", role: .cancel) {
               router.pop()
           }
       } message: {
           Text("Section created successfully.")
       }
    }
}

#Preview {
    SectionView(classId: "")
        .environment(TabRouter())
}
