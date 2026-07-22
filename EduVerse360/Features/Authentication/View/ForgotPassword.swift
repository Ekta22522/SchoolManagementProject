//
//  ForgotPassword.swift
//  EduVerse360
//
//  Created by Ekta Rai on 22/07/2026.
//

import SwiftUI

struct ForgotPassword: View {
    @FocusState private var focusedField : Field?
    @Environment(NavigationRouter.self) private var router
    
    
    @State var viewModel = LoginViewModel()
    
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
            
            VStack(spacing:10){
                Text("Forgot Password?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Enter your email address and we'll send you a password reset link.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.secondaryText)
                
            }
            .padding()
            
            VStack(){
                AppTextField(title: "EMAIL ADDRESS",
                             imageName: "email",
                             placeholder: "Enter your Email",
                             field: .username,
                             error: viewModel.emailError,
                             text: $viewModel.email,
                             focusedField: $focusedField)
                
                Button(action:{
                    
                },
                       label: {
                    HStack(spacing:nil){
                        Text("Send Reset Link")
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .padding()
                        Image("sideArrow")
                    }
                    
                })
                .frame(maxWidth:300, maxHeight: 45 )
                .background(
                    LinearGradient(
                        colors: [.primary,.greenColor], startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                    .cornerRadius(10)
                )
            }
            .padding()
            
            Text("Back to Login")
                .font(.headline)
                .underline()
                .onTapGesture {
                    router.goToLogin()
                }
            Spacer()
                .padding()
        }
    }
}


#Preview {
    ForgotPassword()
}
