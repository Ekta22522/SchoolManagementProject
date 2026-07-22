//
//  LoginView.swift
//  EduVerse360
//
//  Created by Ekta Rai on 10/07/2026.
//
import Foundation
import SwiftUI

enum Field: Hashable{
    case username
    case password
}
struct LoginView: View {

    @FocusState private var focusedField : Field?
    @Environment(NavigationRouter.self) private var router
    @Environment(UserSession.self) private var session
    
    @State var viewModel = LoginViewModel(loginservice: LoginMockAPI())
    
    
    var body: some View {
        
        
        ScrollView{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(maxWidth:.infinity, maxHeight: .infinity)
                //                    .shadow(radius: 10)
                
                VStack{
                    
                    
                    
                    VStack(alignment:.leading){
                        HStack(){
                            Image("eduverselogo")
                                .renderingMode(.template)
                                .foregroundColor(Color.primary)
                            Text("EduVerse 360")
                                .font(.title2)
                                .foregroundColor(Color.primary)
                                .fontWeight(.bold)
                            
                        }
                        .padding()
                        
                        
                        
                        
                        Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                        
                        
                        Text("Stay connected with your school anytime, anywhere.")
                            .font(.subheadline)
                            .frame(width:300,alignment: .leading)
                            .foregroundColor(.secondaryText)
                        
                    }
                    .padding()
                    
                    //Email
                    VStack(alignment:.leading){
                        AppTextField(title: "Email",
                                     imageName: "email",
                                     placeholder: "Enter you Email",
                                     field: .username,
                                     error: viewModel.emailError,
                                     text: $viewModel.email,
                                     focusedField: $focusedField)
                        
                        
                        
                        // Password
                        
                        AppTextField(title:"Password",
                                     imageName: "lock",
                                     placeholder: "Enter your password",
                                     field:.password,
                                     error: viewModel.passwordError,
                                     text:$viewModel.password,
                                     focusedField: $focusedField
                        )
                        
                        
                        
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
                            
                            
                            Text("Remember Me")
                                .font(.subheadline)
                                .foregroundColor(.secondaryText)
                            
                            Spacer()
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    router.goToForgotPassword()
                                }
                            
                            
                        }
                        
                    }
                    .frame(width:300)
                    .padding()
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
                    //Login Button
                    Button( action: {
                        viewModel.checkAllFields()
//                        viewModel.validateEmail()
//                        viewModel.validatePassword()
                        Task{
                            await viewModel.loginUser()
                            if viewModel.isLoginSucceess {
                                viewModel.updateUsername(sess: session)
                                viewModel.saveToken(sess: session)
                                router.goToMainTab()
                            }
                            
                        }
                        
                        
                    }
                            , label: {
                        Text("Login")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .frame(width:200)
                            .padding()
                            .background(Color.primary)
                            .cornerRadius(10)
                        
                        
                    }
                    )
                    
                    // Divider
                    VStack{
                        ZStack() {
                            Divider()
                                .frame(width:300)
                                .padding()
                            Text("OR CONTINUE WITH")
                                .font(.caption)
                                .foregroundColor(.thirdText)
                                .padding()
                                .background(Color.white)
                        }
                        
                    }
                    
                    // signin Google Button
                    
                    Button(action: {
                        
                    } ,
                           label: {
                        Image("google")
                            .foregroundStyle(.gray)
                            .padding()
                        Text("Sign in with Google")
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
                        Text("Don't have an account?")
                            .font(.footnote)
                            .foregroundColor(.secondaryText)
                        Text("Contact Administrator")
                            .font(.footnote)
                            .foregroundColor(Color.primary)
                        
                    }
                    .padding()
                    
                }
                
                
                
            }
            
            if let error = viewModel.generalError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if let error = viewModel.allFieldsError {
                Text(error)
                    .foregroundColor(.red)
            }
            
            if let error = viewModel.userNotFound{
                Text(error)
                .foregroundColor(.red)        }
            
        }
        .onAppear {
            DispatchQueue.main.async {
                focusedField = .username
            }
        }
        
        
        
        
    }
}

#Preview {
    LoginView()
}
