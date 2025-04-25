import Foundation
import Combine

protocol UserServiceProtocol {
    func getCurrentUser() -> AnyPublisher<User, Error>
    func updateUserPreferences(notificationsEnabled: Bool, theme: String) -> AnyPublisher<Void, Error>
    func updateDefaultStudyDuration(_ duration: TimeInterval) -> AnyPublisher<Void, Error>
}

protocol StudyServiceProtocol {
    func getNextSession() -> AnyPublisher<StudySession?, Error>
    func getWeeklyProgress() -> AnyPublisher<[(day: String, hours: Double)], Error>
    func startSession(taskId: String, duration: TimeInterval) -> AnyPublisher<Void, Error>
    func endCurrentSession() -> AnyPublisher<Void, Error>
    func searchTasks(query: String) -> AnyPublisher<[StudyTask], Error>
}

protocol NotificationServiceProtocol {
    func getRecentNotifications() -> AnyPublisher<[NotificationItem], Error>
    func markAsRead(notificationId: String) -> AnyPublisher<Void, Error>
    func clearAllNotifications() -> AnyPublisher<Void, Error>
} 