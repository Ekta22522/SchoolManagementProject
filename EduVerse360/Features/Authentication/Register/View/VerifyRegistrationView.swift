//
//  VerifyRegistrationView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 08/08/2026.
//

import SwiftUI

struct VerifyRegistrationView: View {
    @Environment(NavigationRouter.self) private var router
    @State private var viewModel = VerifyRegistrationViewModel()
    
    init(email: String) {
          let viewModel = VerifyRegistrationViewModel()
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
                
                HStack(){
                    SecureField("Enter Your OTP",text: $viewModel.otp)
                }
                .padding()
                .frame(width:300, height:45)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 4)
                    
                )
                
                Button(action:{
                    Task{
                        print("Email:", viewModel.email)
                        print("OTP:", viewModel.otp)
                        await viewModel.verifyRegister()
                        if viewModel.isVerificationSucess{
                            router.goToLogin()
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
    VerifyRegistrationView(email:"test@gmail.com")
}
