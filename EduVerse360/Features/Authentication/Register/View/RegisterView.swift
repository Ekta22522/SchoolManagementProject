//
//  RegisterView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 11/07/2026.
//

import SwiftUI

struct RegisterView: View {
    
    @State var viewModel = RegisterViewModel(registerservice: RegisterServerAPI())
    var body: some View {
        ScrollView {
            
            //            ZStack{
            //
            //                RoundedRectangle(cornerRadius: 10)
            //                    .fill(.white)
            //                    .frame(width:350, height: 750)
            //                //                .shadow(radius: 10)
            //                //
            //
            VStack{
                
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
                    //personal information
                    if viewModel.currentStep == 1{
                        VStack(alignment:.leading) {
                            Text("Full Name")
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                            
                            HStack {
                                Image(systemName: "person")
                                    .padding()
                                TextField("john doe",text: $viewModel.fullName)
                                
                                
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
                                TextField("johndoe@gmail",text: $viewModel.fullName)
                                
                                
                            }
                            .frame(width:300, height:45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textFieldColor, lineWidth: 1)
                                
                            )
                            
                            
                            
                        }
                        .padding(.bottom)
                        
                        //Phone number
                        VStack(alignment:.leading) {
                            Text("Phone Number")
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                            HStack(){
                                Image(systemName: "phone")
                                TextField("+977",text: $viewModel.phoneNumber)
                                
                            }
                            .padding()
                            .frame(width:300, height:45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textFieldColor, lineWidth: 1)
                                
                            )
                            
                            
                        }
                        .padding(.bottom)
                        
                        Button(action:{
                            viewModel.nextStep()
                        }, label: {
                            Text("Next")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        })
                        .frame(maxWidth: 100, maxHeight: 100)
                        .padding()
                        .background(Color.primary)
                        .cornerRadius(10)
                        
                    }
                    
                    //School name & Role
                    
                    if viewModel.currentStep == 2{
                        VStack(alignment:.leading) {
                            Text("School Name")
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                            HStack(){
                                Image(systemName: "building")
                                TextField("Itahari International College",text: $viewModel.schoolName)
                                
                            }
                            .padding()
                            .frame(width:300, height:45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textFieldColor, lineWidth: 1)
                                
                            )
                        }
                        
                        //Role
                        
//                        VStack(alignment:.leading) {
//                            Text("Your Role")
//                                .font(.caption)
//                                .foregroundColor(Color.black)
//                                .fontWeight(.semibold)
//                            Menu {
//                                Button("Student") {
//                                    viewModel.role = "Student"
//                                }
//                                
//                                Button("Teacher") {
//                                    viewModel.role = "Teacher"
//                                }
//                                
//                                Button("School") {
//                                    viewModel.role = "School"
//                                }
//                                
//                            } label: {
//                                HStack {
//                                    Text(viewModel.role.rawValue)
//                                    
//                                    Spacer()
//                                    
//                                    Image("dropdown")
//                                }
//                                .padding()
//                                .frame(width: 300)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.textFieldColor, lineWidth: 1)
//                                    
//                                )
//                                
//                            }
//                            
//                        }
                        
                        HStack(spacing:20) {
                            Button(action:{
                                viewModel.previousStep()
                            },label: {
                                Text("Back")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            })
                            .frame(maxWidth: 100, maxHeight: 100)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(10)
                            
                            
                            Button(action:{
                                viewModel.nextStep()
                            },label: {
                                Text("Next")
                                    .foregroundColor(Color.white)
                                    .fontWeight(.bold)
                            })
                            .frame(maxWidth: 100, maxHeight: 100)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(10)
                        }
                    }
                    
                    
                    //password
                    if viewModel.currentStep == 3 {
                        VStack(alignment:.leading) {
                            Text("Password")
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                            HStack(){
                                Image("lock")
                                TextField("+977",text: $viewModel.phoneNumber)
                                
                            }
                            .padding()
                            .frame(width:300, height:45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.textFieldColor, lineWidth: 1)
                                
                            )
                            
                            
                        }
                        
                        //Confirm password
                        
                        
                        VStack(alignment:.leading) {
                            Text("Confirm Password")
                                .font(.caption)
                                .foregroundColor(Color.black)
                                .fontWeight(.semibold)
                            HStack(){
                                Image("lock")
                                TextField("+977",text: $viewModel.phoneNumber)
                                
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
                        
                        //Create Account Button
                        Button( action: {
                            Task{
                                await viewModel.createUser()
                            }
                        }, label: {
                            Text("Create Account")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .frame(width:200)
                                .padding()
                                .background(Color.primary)
                                .cornerRadius(10)
                            
                            
                        }
                        )
                        
                        Button(action:{
                            viewModel.previousStep()
                        },label: {
                            Text("Back")
                                .foregroundColor(Color.white)
                                .fontWeight(.bold)
                        })
                        .frame(maxWidth: 100, maxHeight: 100)
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
            .alert(
                "Error",
                isPresented: Binding(
                    get: { viewModel.showAlert },
                    set: { viewModel.showAlert = $0 }
                )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage ?? "Error 1")
            }
        }
    }
}

#Preview {
    RegisterView()
}
