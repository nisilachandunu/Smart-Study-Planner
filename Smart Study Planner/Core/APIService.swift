//
//  APIService.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-19.
//

import Foundation

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:3000"
    private var token: String?

    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("🚀 Sending login request to: \(url)")
        print("📩 Request headers: \(request.allHTTPHeaderFields ?? [:])")

        let body: [String: String] = ["email": email, "password": password]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request body: \(jsonString)")
            }
        } catch {
            print("❌ Failed to encode request body: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let responseData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let responseData = responseData,
                      let userDict = responseData["user"] as? [String: Any],
                      let id = userDict["id"] as? String,
                      let email = userDict["email"] as? String,
                      let name = userDict["name"] as? String,
                      let token = responseData["token"] as? String else {
                    let decodeError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
                    completion(.failure(decodeError))
                    return
                }
                let user = User(
                    id: id,
                    email: email,
                    name: name,
                    token: token,
                    notificationEnabled: (userDict["notificationEnabled"] as? Bool) ?? true,
                    theme: (userDict["theme"] as? String) ?? "light",
                    defaultStudyDuration: (userDict["defaultStudyDuration"] as? Double) ?? 3600
                )
                print("✅ Successfully decoded user: \(user)")
                self.token = user.token
                completion(.success(user))
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // Async/await version of login
    func login(email: String, password: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            login(email: email, password: password) { result in
                switch result {
                case .success(let user):
                    continuation.resume(returning: user)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func register(email: String, password: String, name: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/api/auth/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("🚀 Sending register request to: \(url)")
        print("📩 Request headers: \(request.allHTTPHeaderFields ?? [:])")

        let body: [String: String] = ["email": email, "password": password, "name": name]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request body: \(jsonString)")
            }
        } catch {
            print("❌ Failed to encode request body: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let responseData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let responseData = responseData,
                      let userDict = responseData["user"] as? [String: Any],
                      let id = userDict["id"] as? String,
                      let email = userDict["email"] as? String,
                      let name = userDict["name"] as? String,
                      let token = responseData["token"] as? String else {
                    let decodeError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
                    completion(.failure(decodeError))
                    return
                }
                let user = User(
                    id: id,
                    email: email,
                    name: name,
                    token: token,
                    notificationEnabled: (userDict["notificationEnabled"] as? Bool) ?? true,
                    theme: (userDict["theme"] as? String) ?? "light",
                    defaultStudyDuration: (userDict["defaultStudyDuration"] as? Double) ?? 3600
                )
                print("✅ Successfully decoded user: \(user)")
                self.token = user.token
                completion(.success(user))
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    // Async/await version of register
    func register(email: String, password: String, name: String) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            register(email: email, password: password, name: name) { result in
                switch result {
                case .success(let user):
                    continuation.resume(returning: user)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func registerWithApple(identityToken: String, user: AppleUser?, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register-apple")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("🚀 Sending Apple register request to: \(url)")
        print("📩 Request headers: \(request.allHTTPHeaderFields ?? [:])")

        let body: [String: Any] = [
            "identityToken": identityToken,
            "user": user?.toDictionary() ?? [:]
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request body: \(jsonString)")
            }
        } catch {
            print("❌ Failed to encode request body: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let responseData = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                guard let responseData = responseData,
                      let userDict = responseData["user"] as? [String: Any],
                      let id = userDict["id"] as? String,
                      let email = userDict["email"] as? String,
                      let name = userDict["name"] as? String,
                      let token = responseData["token"] as? String else {
                    let decodeError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
                    completion(.failure(decodeError))
                    return
                }
                let user = User(
                    id: id,
                    email: email,
                    name: name,
                    token: token,
                    notificationEnabled: (userDict["notificationEnabled"] as? Bool) ?? true,
                    theme: (userDict["theme"] as? String) ?? "light",
                    defaultStudyDuration: (userDict["defaultStudyDuration"] as? Double) ?? 3600
                )
                print("✅ Successfully decoded user: \(user)")
                self.token = user.token
                completion(.success(user))
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Async/await version of registerWithApple
    func registerWithApple(identityToken: String, user: AppleUser?) async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            registerWithApple(identityToken: identityToken, user: user) { result in
                switch result {
                case .success(let user):
                    continuation.resume(returning: user)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func requestPasswordReset(email: String, completion: @escaping (Result<OTPResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/forgot-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        print("🚀 Sending password reset request to: \(url)")
        print("📩 Request headers: \(request.allHTTPHeaderFields ?? [:])")

        let body: [String: String] = ["email": email]
        do {
            request.httpBody = try JSONEncoder().encode(body)
            if let jsonString = String(data: request.httpBody!, encoding: .utf8) {
                print("📤 Request body: \(jsonString)")
            }
        } catch {
            print("❌ Failed to encode request body: \(error)")
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let response = try JSONDecoder().decode(OTPResponse.self, from: data)
                print("✅ Successfully decoded OTP response: \(response)")
                completion(.success(response))
            } catch {
                print("❌ Decoding error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Async/await version of requestPasswordReset
    func requestPasswordReset(email: String) async throws -> OTPResponse {
        return try await withCheckedThrowingContinuation { continuation in
            requestPasswordReset(email: email) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func verifyOTP(otpId: String, otp: String, completion: @escaping (Result<VerifyOTPResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/verify-otp")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "otpId": otpId,
            "otp": otp
        ]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let response = try JSONDecoder().decode(VerifyOTPResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Async/await version of verifyOTP
    func verifyOTP(otpId: String, otp: String) async throws -> VerifyOTPResponse {
        return try await withCheckedThrowingContinuation { continuation in
            verifyOTP(otpId: otpId, otp: otp) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func resetPassword(resetToken: String, newPassword: String, completion: @escaping (Result<ResetPasswordResponse, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/reset-password")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "resetToken": resetToken,
            "newPassword": newPassword
        ]
        
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📥 HTTP Response Status: \(httpResponse.statusCode)")
                print("📥 Response headers: \(httpResponse.allHeaderFields)")
                
                // Handle different HTTP status codes
                switch httpResponse.statusCode {
                case 200...299:
                    break // Success, continue with data processing
                case 400:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                    return
                case 401:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unauthorized"])
                    completion(.failure(error))
                    return
                case 403:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Forbidden"])
                    completion(.failure(error))
                    return
                case 404:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Resource not found"])
                    completion(.failure(error))
                    return
                case 500...599:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])
                    completion(.failure(error))
                    return
                default:
                    let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected error"])
                    completion(.failure(error))
                    return
                }
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                print("❌ No data received from server")
                completion(.failure(noDataError))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Raw response data: \(responseString)")
            }

            do {
                let response = try JSONDecoder().decode(ResetPasswordResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Async/await version of resetPassword
    func resetPassword(resetToken: String, newPassword: String) async throws -> ResetPasswordResponse {
        return try await withCheckedThrowingContinuation { continuation in
            resetPassword(resetToken: resetToken, newPassword: newPassword) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
