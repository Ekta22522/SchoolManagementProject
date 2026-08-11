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
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(maxWidth:350,maxHeight:350)
                .shadow(radius: 10)
            
            VStack{
                Text("Verify Your OTP")
                    .font(.largeTitle)
                    .foregroundColor(Color.primary)
                    .fontWeight(.bold)
                
                AppTextField(title: "Username",
                             imageName: "",
                             placeholder: "Enter your username",
                             field: .username,
                             error: viewModel.emailError,
                             text: $viewModel.username,
                             focusedField: $focusedField)
                VStack(){
                    Text("Otp")
                    SecureField("Enter Your OTP",text: $viewModel.otp)
                }
                .padding()
                .frame(width:300, height:45)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 4)
                    
                )
                
                Button(action:{
                    router.goToResetPassword(email: viewModel.email )
                    Task{
                        print("Email:", viewModel.email)
                        print("OTP:", viewModel.otp)
                        await viewModel.verifyOtp()
                        if viewModel.isVerifyOtpSucess{
                           
                        }
                    }
                }
                       ,label:{
                    Text ("Ok")
                        .foregroundColor(Color.white)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    
                })
                
                .frame(maxWidth: 80, maxHeight: 30)
                .padding()
                .background(Color.primary)
                .cornerRadius(10)
                .padding()
                
            }
        }
    }
}

#Preview {
    VerifyOtpView(email: "")
}
