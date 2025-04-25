//
//  AppleSignInHandler.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-22.
//
import AuthenticationServices

class AppleSignInHandler: NSObject, ASAuthorizationControllerDelegate {
    var completion: ((Bool, String?, String?, Data?) -> Void)?

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let name = [fullName?.givenName, fullName?.familyName].compactMap { $0 }.joined(separator: " ")
            let identityToken = appleIDCredential.identityToken
            completion?(true, email, name.isEmpty ? nil : name, identityToken)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
        completion?(false, nil, nil, nil)
    }
}
