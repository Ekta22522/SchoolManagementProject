//
//  VerifyOtpView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/08/2026.
//

import SwiftUI
import Foundation
struct VerifyOtpView: View {
    
    @State var viewModel = VerifyOtpViewModel()
    @FocusState private var focusedField : Field?
    @Environment(NavigationRouter.self) private var router
    
    init(email: String) {
          let viewModel = VerifyOtpViewModel()
          viewModel.email = email
        _viewModel = State(initialValue: viewModel)
      }
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 80)

            Text("Verify Your OTP")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Enter the verification code sent to your email.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom)

            AppTextField(
                title: "Username",
                imageName: "",
                placeholder: "Enter your username",
                field: .username,
                error: viewModel.emailError,
                text: $viewModel.username,
                focusedField: $focusedField
            )

            AppTextField(
                title: "OTP",
                imageName: "",
                placeholder: "Enter your OTP",
                field: .otp,
                error: viewModel.emailError,
                text: $viewModel.otp,
                focusedField: $focusedField
            )

            Button {
                Task {
                    await viewModel.verifyOtp()

                    if viewModel.isVerifyOtpSucess {
                        router.goToResetPassword(email: viewModel.email)
                    }
                }
            } label: {
                Text("Ok")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(width: 80, height: 40)
            }
            .background(Color.primary)
            .cornerRadius(10)
            .padding()

            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    VerifyOtpView(email: "")
}
