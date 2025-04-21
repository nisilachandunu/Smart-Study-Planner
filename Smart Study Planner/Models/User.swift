//
//  User.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-21.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    let token: String
    var notificationEnabled: Bool
    var theme: String
    var defaultStudyDuration: Double
    
    // Custom description for better debugging
    var description: String {
        return "User(id: \(id), email: \(email), name: \(name), token: \(token), notificationEnabled: \(notificationEnabled), theme: \(theme), defaultStudyDuration: \(defaultStudyDuration))"
    }
}

struct AppleUser: Codable {
    let name: String?
    let email: String?

    func toDictionary() -> [String: String?] {
        return [
            "name": name,
            "email": email
        ]
    }
}

struct PasswordResetResponse: Codable {
    let message: String
}

struct OTPResponse: Codable {
    let message: String
    let otpId: String
    
    enum CodingKeys: String, CodingKey {
        case message
        case otpId = "otp_id"  // In case the API uses snake_case
    }
}

struct VerifyOTPResponse: Codable {
    let message: String
    let resetToken: String
}

struct ResetPasswordResponse: Codable {
    let message: String
}
