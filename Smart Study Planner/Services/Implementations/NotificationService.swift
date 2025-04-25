import Foundation
import Combine

class NotificationService: NotificationServiceProtocol {
    private let baseURL = "https://api.smartstudyplanner.com/v1"
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getRecentNotifications() -> AnyPublisher<[NotificationItem], Error> {
        guard let url = URL(string: "\(baseURL)/notifications/recent") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [NotificationItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func markAsRead(notificationId: String) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/notifications/\(notificationId)/read") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func clearAllNotifications() -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/notifications/clear") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
} 