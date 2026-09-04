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

        ScrollView(.vertical, showsIndicators: false) {

            VStack(spacing: 0) {

                // MARK: - Header

                VStack(alignment: .leading, spacing: 10) {

                    HStack {

                        Image("eduverselogo")
                            .renderingMode(.template)
                            .font(.headline)
                            .foregroundColor(Color.primary)

                        Text("EduVerse 360")
                            .font(.title2)
                            .foregroundColor(Color.primary)
                            .fontWeight(.bold)
                    }

                    Text("Create account")
                        .font(.title)
                        .fontWeight(.semibold)

                    Text("Join EduVerse360 to manage your school effortlessly..")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)
                        .frame(width: 300, alignment: .leading)
                }
                .frame(width: 300, alignment: .leading)
                .padding(.bottom, 18)


                // MARK: - Form

                VStack(alignment: .leading, spacing: 14) {

                    // Full Name
                    VStack(alignment: .leading, spacing: 6) {

                        Text("FullName")
                            .font(.caption)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        HStack {

                            Image(systemName: "person")
                                .padding(.leading, 10)

                            TextField(
                                "john doe",
                                text: $viewModel.username
                            )
                        }
                        .frame(width: 300, height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.textFieldColor,
                                    lineWidth: 1
                                )
                        )
                        if let error = viewModel.usernameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }


                    // Email Address
                    VStack(alignment: .leading, spacing: 6) {

                        Text("Email Address")
                            .font(.caption)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        HStack {

                            Image(systemName: "envelope")
                                .padding(.leading, 10)

                            TextField(
                                "",
                                text: $viewModel.email
                            )
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        }
                        .frame(width: 300, height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.textFieldColor,
                                    lineWidth: 1
                                )
                        )
                        if let error = viewModel.emailError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }


                    // Role
                    VStack(alignment: .leading, spacing: 6) {

                        Text("Your Role")
                            .font(.caption)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        Menu {

                            Button("Student") {
                                viewModel.role = .student
                            }

                            Button("Teacher") {
                                viewModel.role = .teacher
                            }

                            Button("School Admin") {
                                viewModel.role = .schoolAdmin
                            }

                        } label: {

                            HStack {

                                Text(viewModel.role.rawValue)

                                Spacer()

                                Image("dropdown")
                            }
                            .padding(.horizontal, 12)
                            .frame(width: 300, height: 45)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.textFieldColor,
                                        lineWidth: 1
                                    )
                            )
                        }
                    }


                    // Password
                    VStack(alignment: .leading, spacing: 6) {

                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)

                        HStack {

                            Image(systemName: "lock")
                                .padding(.leading, 10)

                            SecureField(
                                "",
                                text: $viewModel.password
                            )
                        }
                        .frame(width: 300, height: 45)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color.textFieldColor,
                                    lineWidth: 1
                                )
                        )
                        if let error = viewModel.passwordError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }


                    // MARK: - Terms & Conditions

                    HStack(alignment: .center, spacing: 8) {

                        Button {

                            viewModel.rememberMe.toggle()

                        } label: {

                            Image(
                                systemName:
                                    viewModel.rememberMe
                                ? "checkmark.square.fill"
                                : "square"
                            )
                            .font(.title3)
                            .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)

                        Text("I accept the")
                            .font(.subheadline)
                            .foregroundColor(.secondaryText)

                        +
                        Text(" terms and conditions")
                            .font(.subheadline)
                            .foregroundColor(Color.primary)
                    }
                    .frame(width: 300, alignment: .leading)
                    .padding(.top, 2)


                    // MARK: - Create Account

                    Button {

                        Task {
                            viewModel.checkAllFields()
                            if viewModel.emailError != nil || viewModel.passwordError != nil || viewModel.usernameError != nil {
                                return
                            }
                            await viewModel.createUser()

                            if viewModel.isRegisterSucceess {
                                viewModel.showAlert = true
                            }
                        }

                    } label: {

                        Text("Create Account")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.primary)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                    if let error = viewModel.registerError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .frame(width: 300)


                // MARK: - Divider

                ZStack {

                    Divider()
                        .frame(width: 300)

                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.thirdText)
                        .padding(.horizontal, 10)
                        .background(Color.white)
                }
                .padding(.vertical, 18)


                // MARK: - Google Button

                Button(action: {

                }) {

                    HStack {

                        Image("google")
                            .foregroundStyle(.gray)

                        Text("Continue with Google")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                    }
                    .frame(width: 300, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                Color.textFieldColor,
                                lineWidth: 1
                            )
                    )
                }


                // MARK: - Sign In

                HStack(spacing: 4) {

                    Text("Already have an account?")
                        .font(.subheadline)
                        .foregroundColor(.secondaryText)

                    Text("Sign In")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.primary)
                        .onTapGesture {
                            router.goToLogin()
                        }
                }
                .padding(.top, 18)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 30)
        }
        .alert(
            "Registration Successfull",
            isPresented: Binding(
                get: {
                    viewModel.showAlert
                },
                set: {
                    viewModel.showAlert = $0
                }
            )
        ) {

            Button("OK", role: .cancel) {
            }

        } message: {

            Text(viewModel.alertMessage ?? "")
        }
        .onChange(of: viewModel.showAlert) { oldValue, newValue in

            if oldValue == true && newValue == false {

                router.goToVerifyRegisterationOTP(
                    email: viewModel.email
                )
            }
        }
    }
}


#Preview {
    RegisterSessionView()
}
