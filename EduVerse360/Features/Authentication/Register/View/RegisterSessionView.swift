//
//  RegisterSessionview.swift
//  EduVerse360
//
//  Created by Ekta Rai on 07/08/2026.
//

import SwiftUI

struct RegisterSessionView: View {
    @Environment(NavigationRouter.self) private var router
    @State var viewModel = RegisterViewModel(registerservice: RegisterServerAPI())
    var body: some View {
        ZStack{
        VStack (){
            
            VStack(alignment:.leading){
                VStack(alignment:.leading){
                    HStack(){
                        Image("eduverselogo")
                            .renderingMode(.template)
                            .foregroundColor(Color.primary)
                        Text("EduVerse 360")
                            .underline()
                            .font(.title2)
                            .foregroundColor(Color.primary)
                            .fontWeight(.bold)
                        
                    }
                }
                .padding()
                
                Text("Create account")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                
                Text("Join EduVerse360 to manage your school effortlessly..")
                    .font(.subheadline)
                    .frame(width:300,alignment: .leading)
                    .foregroundColor(.secondaryText)
                
            }
            .padding()
            
            VStack(alignment:.leading){
                    VStack(alignment:.leading) {
                        Text("FullName")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                        
                        HStack {
                            Image(systemName: "person")
                                .padding()
                            TextField("john doe",text: $viewModel.username)
                            
                            
                        }
                        .frame(width:300, height:45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textFieldColor, lineWidth: 1)
                            
                        )
                        
                        
                    }
                    .padding(.bottom)
                    
                    //Email Address
                    
                    VStack(alignment:.leading) {
                        Text("Email Address")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                        
                        
                        HStack {
                            Image("email")
                                .padding()
                            TextField("johndoe@gmail",text: $viewModel.email)
                            
                            
                        }
                        .frame(width:300, height:45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textFieldColor, lineWidth: 1)
                            
                        )
                        
                        
                        
                    }
                    
                    
                    //Role
                    
                    VStack(alignment:.leading, spacing: 10) {
                        Text("Your Role")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                        Menu {
                            Button("Student") {
                                viewModel.role = .student
                            }
                            
                            Button("Super Admin") {
                                viewModel.role = .superAdmin
                            }
                            
                        } label: {
                            HStack {
                                Text(viewModel.role.rawValue)
                                
                                Spacer()
                                
                                Image("dropdown")
                            }
                            .padding()
                            .frame(width: 300)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textFieldColor, lineWidth: 1)
                                
                            )
                            
                        }
                        
                        
                        
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                        
                        HStack(){
                            Image("lock")
                            SecureField("",text: $viewModel.password)
                            
                            
                        }
                        .padding()
                        .frame(width:300, height:45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textFieldColor, lineWidth: 1)
                            
                        )
                    }
                    
                    // Remember me
                    
                    HStack(spacing:10){
                        Button {
                            viewModel.rememberMe.toggle()
                        } label: {
                            Image(systemName: viewModel.rememberMe ? "checkmark.square.fill" : "square")
                                .font(.title3)
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                        
                        HStack(){
                            Text("I agree to the")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                            Text("Terms of Service")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                            Text("and")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                            Text("Privacy Policy")
                                .font(.headline)
                                .foregroundColor(Color.primary)
                            
                        }
                        
                        
                    }
                    
                    
                    .frame(width:300)
                    .padding()
                    
                    VStack(alignment:.trailing){
                        //Create Account Button
                        Button( action: {
                            Task{
                                await viewModel.createUser()
                                if viewModel.isRegisterSucceess{
                                    viewModel.showAlert = true
                                }
                            }
                        }, label: {
                            Text("Create Account")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                            
                            
                            
                        }
                        )
                        .frame(width:200)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
                    }
                    
                    
                    
                    
                    // Divider
                    VStack{
                        ZStack() {
                            Divider()
                                .frame(width:300)
                                .padding()
                            Text("OR")
                                .font(.caption)
                                .foregroundColor(.thirdText)
                                .padding()
                                .background(Color.white)
                        }
                        
                    }
                    
                    // Cotinue Google Button
                    
                    Button(action: {
                        
                    } ,
                           label: {
                        Image("google")
                            .foregroundStyle(.gray)
                            .padding()
                        Text("Continue with Google")
                            .foregroundColor(Color.black)
                            .fontWeight(.semibold)
                    })
                    .frame(width:300,height:50)
                    .background(
                        RoundedRectangle(cornerRadius:10)
                            .fill(Color.white)
                            .stroke(Color.textFieldColor, lineWidth: 1)
                    )
                    
                    //last portion
                    HStack(){
                        Text("Already have an account?")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)
                        Text("Sign In")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.primary)
                            .onTapGesture {
                                
                            }
                        
                    }
                    .padding()
                    
                }
                
            }
            
        }
        .alert(
            "Registration Successfull",
            isPresented: Binding(
                get: { viewModel.showAlert },
                set: { viewModel.showAlert = $0 }
            )
        ) {
            Button("OK", role: .cancel) {
            }
            .onChange(of: viewModel.showAlert) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    router.goToVerifyRegisterationOTP(
                        email: viewModel.email
                    )
                   
                }
            }
        } message: {
            Text(viewModel.alertMessage ?? "")
        }
    }
    }


#Preview {
    RegisterSessionView()
}
