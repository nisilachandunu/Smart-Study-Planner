//
//  LoginViewModel.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-23.
//

import SwiftUI
import AuthenticationServices
import Foundation
import LocalAuthentication
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    private var cancellables = Set<AnyCancellable>()
    private let userService: UserServiceProtocol
    private let apiService = APIService.shared

    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        let credentials = KeychainService.shared.getCredentials()
        if let savedEmail = credentials.email, let savedPassword = credentials.password {
            self.email = savedEmail
            self.password = savedPassword
        }
    }

    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return
        }
        
        apiService.login(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    print("Login successful for user: \(user.email)")
                    // Save credentials for biometric authentication
                    let saved = KeychainService.shared.saveCredentials(email: self?.email ?? "", password: self?.password ?? "")
                    print("Credentials saved to Keychain: \(saved)")
                    self?.currentUser = user
                    self?.isAuthenticated = true
                    UserDefaults.standard.set(true, forKey: "isAuthenticated")
                    self?.errorMessage = nil
                case .failure(let error):
                    print("Login failed: \(error.localizedDescription)")
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                    UserDefaults.standard.set(false, forKey: "isAuthenticated")
                }
            }
        }
    }

    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        let handler = AppleSignInHandler()
        handler.completion = { [weak self] success, email, name, identityToken in
            DispatchQueue.main.async {
                if success, let email = email, let tokenData = identityToken, let tokenString = String(data: tokenData, encoding: .utf8) {
                    let appleUser = AppleUser(name: name, email: email)
                    self?.apiService.registerWithApple(identityToken: tokenString, user: appleUser) { result in
                        switch result {
                        case .success(let user):
                            print("Apple sign-in successful for user: \(user.email)")
                            let saved = KeychainService.shared.saveCredentials(email: email, password: UUID().uuidString)
                            print("Credentials saved to Keychain: \(saved)")
                            self?.currentUser = user
                            self?.isAuthenticated = true
                            UserDefaults.standard.set(true, forKey: "isAuthenticated")
                            self?.errorMessage = nil
                        case .failure(let error):
                            print("Apple sign-in failed: \(error.localizedDescription)")
                            self?.errorMessage = error.localizedDescription
                            self?.isAuthenticated = false
                            UserDefaults.standard.set(false, forKey: "isAuthenticated")
                        }
                    }
                } else {
                    self?.errorMessage = "Apple Sign-In failed"
                    self?.isAuthenticated = false
                    UserDefaults.standard.set(false, forKey: "isAuthenticated")
                }
            }
        }
        controller.delegate = handler
        controller.performRequests()
    }

    func signInWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Log in to your account"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        // Get stored credentials and authenticate
                        let credentials = KeychainService.shared.getCredentials()
                        if let email = credentials.email, let password = credentials.password {
                            self?.email = email
                            self?.password = password
                            self?.login()
                        } else {
                            self?.errorMessage = "No stored credentials found"
                        }
                    } else {
                        self?.errorMessage = error?.localizedDescription ?? "Authentication failed"
                    }
                }
            }
        } else {
            errorMessage = error?.localizedDescription ?? "Biometric authentication not available"
        }
    }
}
