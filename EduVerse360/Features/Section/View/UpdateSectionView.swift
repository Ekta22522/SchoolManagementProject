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
    @Environment(TabRouter.self) private var router
    @FocusState private var focusedField : Field?
    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            if let errorMessage = viewModel.errorMessage, viewModel.section == nil {
                Text(errorMessage)
                    .foregroundStyle(Color.secondaryText)
            } else if viewModel.section != nil {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // MARK: Header

                        Text("Update Section")
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        // MARK: Form

                        VStack(spacing: 4) {
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
                                    await viewModel.updateSection(id: sectionId)
                                }
                            },label:{
                                Group {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text("Update")
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
            } else {
                ProgressView()
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
        .environment(TabRouter())
}
