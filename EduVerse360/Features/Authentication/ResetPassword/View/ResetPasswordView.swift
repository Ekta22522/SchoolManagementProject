//
//  ResetPasswordView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/08/2026.
//

import SwiftUI
import Foundation

struct ResetPasswordView: View {
    
    @State var viewModel = ResetPasswordViewModel()
    @FocusState private var focusedField : Field?
    @Environment(NavigationRouter.self) private var router
    
    init(email: String) {
          let viewModel = ResetPasswordViewModel()
          viewModel.email = email
          _viewModel = State(initialValue: viewModel)
      }
    
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
                Text("Create New Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Your new password must be different from previous passwords.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.secondaryText)
                
            }
            .padding()
            
            VStack(){
                
                AppTextField(title: "New Password",
                             imageName: "lock",
                             placeholder: "Enter New Passowrd",
                             field: .username,
                             error: viewModel.emailError,
                             text: $viewModel.password,
                             focusedField: $focusedField)
                
                AppTextField(title: "Confirm Password",
                             imageName: "lock",
                             placeholder: "Confirm Passowrd",
                             field: .username,
                             error: viewModel.emailError,
                             text: $viewModel.confirmPassword,
                             focusedField: $focusedField)
                
                Button(action:{
                    Task{
                        await viewModel.resetPassword()
                        if viewModel.isResetPasswordSucess{
                            router.goToLogin()
                        }
                    }
                },
                       label: {
                    HStack(spacing:nil){
                        Text("ok")
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
    ResetPasswordView(email: "")
}
