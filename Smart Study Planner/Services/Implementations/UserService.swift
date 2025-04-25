import Foundation
import Combine

class UserService: UserServiceProtocol {
    private let baseURL = "https://api.smartstudyplanner.com/v1"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getCurrentUser() -> AnyPublisher<User, Error> {
        guard let url = URL(string: "\(baseURL)/users/me") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func updateUserPreferences(notificationsEnabled: Bool, theme: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/users/preferences") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "notifications_enabled": notificationsEnabled,
            "theme": theme
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func updateDefaultStudyDuration(_ duration: TimeInterval) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/users/study-duration") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: TimeInterval] = ["default_duration": duration]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
} 