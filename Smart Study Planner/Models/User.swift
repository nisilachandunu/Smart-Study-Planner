//
//  User.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-21.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String           // Unique identifier for the user
    let email: String        // User's email for account recovery and notifications
    let name: String         // User's name for personalization
    let token: String        // Authentication token for API requests
    var notificationEnabled: Bool  // Preference for receiving notifications
    var theme: String        // UI theme preference ("light" or "dark")
    var defaultStudyDuration: Double  // Default study session duration in seconds
    
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
