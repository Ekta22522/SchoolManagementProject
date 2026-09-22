//
//  VerifyRegistrationView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 08/08/2026.
//

import SwiftUI

struct VerifyRegistrationView: View {
    @Environment(AuthRouter.self) private var router
    @State private var viewModel = VerifyRegistrationViewModel()
    @FocusState private var focusedField: Field?

    init(email: String) {
          let viewModel = VerifyRegistrationViewModel()
          viewModel.email = email

          _viewModel = State(initialValue: viewModel)
      }

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Verify Your OTP")
                    .font(.largeTitle)
                    .foregroundColor(Color.primary)
                    .fontWeight(.bold)

                Text("Enter the verification code sent to your email.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        VStack(spacing: 16) {
                            AppTextField(
                                title: "OTP",
                                imageName: "",
                                placeholder: "Enter Your OTP",
                                field: .otp,
                                error: nil,
                                text: $viewModel.otp,
                                focusedField: $focusedField
                            )

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            Button(action: {
                                Task {
                                    print("Email:", viewModel.email)
                                    print("OTP:", viewModel.otp)
                                    await viewModel.verifyRegister()
                                }
                            }, label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Ok")
                                        .foregroundColor(Color.white)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            })
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(16)
                    )
            }
            .padding(.horizontal, 16)
        }
        .alert(
            "Verified",
            isPresented: $viewModel.isVerificationSucess
        ) {
            Button("OK", role: .cancel) {
                router.popToRoot()
            }
        } message: {
            Text("Your account has been verified. Please sign in.")
        }
    }
}

#Preview {
    VerifyRegistrationView(email:"test@gmail.com")
}
