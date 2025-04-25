//
//  LoginView.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-22.
//

import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var navigateToForgotPassword: Bool = false
    @State private var navigateToSignUp: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("loginViewImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                Text("Welcome Back")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button(action: {
                    viewModel.signInWithBiometrics()
                }) {
                    HStack {
                        Image(systemName: "touchid")
                        Text("Sign in with Touch ID")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                Button(action: {
                    viewModel.signInWithBiometrics()
                }) {
                    HStack {
                        Image(systemName: "faceid")
                        Text("Sign in with Face ID")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }

                Text("Or continue with")
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    viewModel.login()
                }) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    navigateToForgotPassword = true
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.top, 10)

                SignInWithAppleButton()
                    .frame(width: 280, height: 45)
                    .onTapGesture {
                        viewModel.signInWithApple()
                    }

                Button(action: {
                    navigateToSignUp = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                .padding(.top, 5)
            }
            .padding()
            .background(Color.white)
            .alert(isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Alert(
                    title: Text("Authentication"),
                    message: Text(viewModel.errorMessage ?? "Unknown error"),
                    dismissButton: .default(Text("OK"))
                )
            }
            .navigationTitle("Login")
            .navigationBarHidden(true)
            .background(
                NavigationLink(destination: ForgotPasswordView(), isActive: $navigateToForgotPassword) { EmptyView() }
            )
            .background(
                NavigationLink(destination: RegisterView(), isActive: $navigateToSignUp) { EmptyView() }
            )
            .background(
                NavigationLink(destination: DashboardView(), isActive: $viewModel.isAuthenticated) { EmptyView() }
            )
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                DashboardView()
            }
        }
    }
}

struct ForgotPasswordView: View {
    var body: some View {
        Text("Forgot Password View")
    }
}

struct SignUpView: View {
    var body: some View {
        Text("Sign Up View")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
