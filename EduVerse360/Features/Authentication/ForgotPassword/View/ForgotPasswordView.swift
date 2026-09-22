//
//  ForgotPassword.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/07/2026.
//

import SwiftUI

struct ForgotPasswordView: View {
    @FocusState private var focusedField : Field?
    @Environment(AuthRouter.self) private var router
    
    
    
    @State var viewModel = ForgotPasswordViewModel()
    
    var body: some View {
        VStack(alignment:.center){
            
            Spacer()
            Circle()
                .fill(Color.blue)
                .frame(maxWidth:100, maxHeight: 100)
                .opacity(0.2)
                .overlay(
                    Image("lock")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(Color.primary)
                        .frame(maxWidth:30,maxHeight: 45)
                    
                )
            
            VStack{
                Text("Forgot Password?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Enter your email address and we'll send you an OTP to verify your identity.")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.secondaryText)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                
                
                
                AppTextField(title: "EMAIL ADDRESS",
                             imageName: "email",
                             placeholder: "Enter your Email",
                             field: .username,
                             error: viewModel.emailError,
                             text: $viewModel.email,
                             focusedField: $focusedField)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Button(action:{
                    Task{
                        await viewModel.forgotPassword()
                        if viewModel.isForgotPasswordSuccess{
                            router.push(AuthRoute.verifyOtp(email: viewModel.email))
                        }
                    }
                },
                       label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        HStack(spacing:nil){
                            Text("Send otp")
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                                .padding()
                            Image("sideArrow")
                        }
                    }

                })
                .frame(maxWidth:300, maxHeight: 45 )
                .background(Color.primary)
                .cornerRadius(10)
            }
            .padding()
            
            Text("Back to Login")
                .font(.headline)
                .underline()
                .onTapGesture {
                    router.popToRoot()
                }
            Spacer()
                .padding()
        }
     
    }
}


#Preview {
    ForgotPasswordView()
}
