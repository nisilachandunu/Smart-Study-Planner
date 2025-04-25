////
////  SignUpViewModel.swift
////  Smart Study Planner
////
////  Created by Nisila on 2025-04-23.
////
//
//import SwiftUI
//
//class SignUpViewModel: ObservableObject {
//    @Published var name: String = ""
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var errorMessage: String?
//    @Published var isAuthenticated: Bool {
////        didSet {
//            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
//        }
//    }
//    @Published var currentUser: User?
//
//    init() {
//        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
//    }
//
//    func signUp() {
//        APIService.shared.register(email: email, password: password, name: name) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let user):
//                    print("Sign-up successful for user: \(user.email)")
//                    let saved = KeychainService.shared.saveCredentials(email: self?.email ?? "", password: self?.password ?? "")
//                    print("Credentials saved to Keychain: \(saved)")
//                    self?.currentUser = user
//                    self?.isAuthenticated = true
//                    self?.errorMessage = nil
//                case .failure(let error):
//                    print("Sign-up failed: \(error.localizedDescription)")
//                    self?.errorMessage = error.localizedDescription
//                    self?.isAuthenticated = false
//                }
//            }
//        }
//    }
//
//    func signUpWithApple(identityToken: String, user: AppleUser?) {
//        APIService.shared.registerWithApple(identityToken: identityToken, user: user) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let user):
//                    print("Apple sign-up successful for user: \(user.email)")
//                    let saved = KeychainService.shared.saveCredentials(email: user.email, password: UUID().uuidString)
//                    print("Credentials saved to Keychain: \(saved)")
//                    self?.currentUser = user
//                    self?.isAuthenticated = true
//                    self?.errorMessage = nil
//                case .failure(let error):
//                    print("Apple sign-up failed: \(error.localizedDescription)")
//                    self?.errorMessage = error.localizedDescription
//                    self?.isAuthenticated = false
//                }
//            }
//        }
//    }
//}
