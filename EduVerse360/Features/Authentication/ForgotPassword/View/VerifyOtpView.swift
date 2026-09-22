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
    @Environment(AuthRouter.self) private var router

    init(email: String) {
          let viewModel = VerifyOtpViewModel()
          viewModel.email = email
        _viewModel = State(initialValue: viewModel)
      }
    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                    .frame(height: 40)

                Text("Verify Your OTP")
                    .font(.largeTitle)
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
                                title: "Username",
                                imageName: "",
                                placeholder: "Enter your username",
                                field: .username,
                                error: nil,
                                text: $viewModel.username,
                                focusedField: $focusedField
                            )

                            AppTextField(
                                title: "OTP",
                                imageName: "",
                                placeholder: "Enter your OTP",
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

                            Button {
                                Task {
                                    await viewModel.verifyOtp()

                                    if viewModel.isVerifyOtpSucess {
                                        router.push(AuthRoute.resetPassword(email: viewModel.email))
                                    }
                                }
                            } label: {
                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Text("Ok")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(16)
                    )

                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    VerifyOtpView(email: "")
}
