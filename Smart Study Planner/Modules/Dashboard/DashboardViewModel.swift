import Foundation
import Combine
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var userName: String = "John Doe"
    @Published var unreadNotifications: Int = 3
    @Published var nextSession: StudySession?
    @Published var weeklyProgress: [(day: String, hours: Double)] = []
    @Published var estimatedFocusTime: TimeInterval = 5400 // 1.5 hours
    @Published var hasActiveSession: Bool = true
    @Published var currentSessionRemainingTime: TimeInterval = 1800 // 30 minutes
    @Published var recentNotifications: [NotificationItem] = []
    @Published var searchQuery: String = ""
    @Published var searchResults: [SearchResult] = []
    @Published var isSearching: Bool = false
    
    // Dummy data for search
    private let dummyTasks: [SearchResult] = [
        SearchResult(id: "1", title: "Mathematics Assignment", subject: "Mathematics", dueDate: Date().addingTimeInterval(86400), priority: .high),
        SearchResult(id: "2", title: "Physics Lab Report", subject: "Physics", dueDate: Date().addingTimeInterval(172800), priority: .medium),
        SearchResult(id: "3", title: "Chemistry Quiz", subject: "Chemistry", dueDate: Date().addingTimeInterval(259200), priority: .high),
        SearchResult(id: "4", title: "Biology Research Paper", subject: "Biology", dueDate: Date().addingTimeInterval(345600), priority: .low),
        SearchResult(id: "5", title: "History Essay", subject: "History", dueDate: Date().addingTimeInterval(432000), priority: .medium),
        SearchResult(id: "6", title: "English Literature Review", subject: "English", dueDate: Date().addingTimeInterval(518400), priority: .high),
        SearchResult(id: "7", title: "Computer Science Project", subject: "Computer Science", dueDate: Date().addingTimeInterval(604800), priority: .high),
        SearchResult(id: "8", title: "Geography Presentation", subject: "Geography", dueDate: Date().addingTimeInterval(691200), priority: .low),
        SearchResult(id: "9", title: "Art Portfolio", subject: "Art", dueDate: Date().addingTimeInterval(777600), priority: .medium),
        SearchResult(id: "10", title: "Music Theory Exam", subject: "Music", dueDate: Date().addingTimeInterval(864000), priority: .high)
    ]
    
    private var cancellables = Set<AnyCancellable>()
    private let userService: UserServiceProtocol
    private let studyService: StudyServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    init(userService: UserServiceProtocol = UserService(),
         studyService: StudyServiceProtocol = StudyService(),
         notificationService: NotificationServiceProtocol = NotificationService()) {
        self.userService = userService
        self.studyService = studyService
        self.notificationService = notificationService
        
        setupBindings()
        loadDummyData()
    }
    
    private func setupBindings() {
        // Listen for search query changes
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    private func loadDummyData() {
        // Dummy next session
        nextSession = StudySession(
            sessionID: "1",
            taskID: "task1",
            startTime: Date().addingTimeInterval(3600), // 1 hour from now
            endTime: Date().addingTimeInterval(7200),   // 2 hours from now
            duration: 3600
        )
        
        // Dummy weekly progress with more varied data
        weeklyProgress = [
            ("Mon", 2.5),
            ("Tue", 3.0),
            ("Wed", 1.5),
            ("Thu", 4.0),
            ("Fri", 2.0),
            ("Sat", 3.5),
            ("Sun", 1.0)
        ]
        
        // Dummy notifications with more variety
        recentNotifications = [
            NotificationItem(
                id: "1",
                message: "Your Mathematics study session starts in 30 minutes",
                timestamp: Date().addingTimeInterval(-300), // 5 minutes ago
                isRead: false,
                type: .sessionReminder
            ),
            NotificationItem(
                id: "2",
                message: "You've completed 5 study sessions this week!",
                timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
                isRead: false,
                type: .achievementUnlocked
            ),
            NotificationItem(
                id: "3",
                message: "Physics assignment deadline approaching",
                timestamp: Date().addingTimeInterval(-7200), // 2 hours ago
                isRead: true,
                type: .deadlineApproaching
            ),
            NotificationItem(
                id: "4",
                message: "You've maintained a 7-day study streak!",
                timestamp: Date().addingTimeInterval(-86400), // 1 day ago
                isRead: true,
                type: .studyStreak
            ),
            NotificationItem(
                id: "5",
                message: "New study material available for Chemistry",
                timestamp: Date().addingTimeInterval(-90000), // 25 hours ago
                isRead: false,
                type: .newMaterial
            ),
            NotificationItem(
                id: "6",
                message: "Your study group meeting is tomorrow",
                timestamp: Date().addingTimeInterval(-93600), // 26 hours ago
                isRead: true,
                type: .groupMeeting
            ),
            NotificationItem(
                id: "7",
                message: "You've earned a new badge: Early Bird",
                timestamp: Date().addingTimeInterval(-97200), // 27 hours ago
                isRead: true,
                type: .achievementUnlocked
            ),
            NotificationItem(
                id: "8",
                message: "Biology quiz results are now available",
                timestamp: Date().addingTimeInterval(-100800), // 28 hours ago
                isRead: false,
                type: .quizResult
            )
        ]
        
        // Start a timer to update the current session remaining time
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, self.hasActiveSession else { return }
                if self.currentSessionRemainingTime > 0 {
                    self.currentSessionRemainingTime -= 1
                } else {
                    self.hasActiveSession = false
                }
            }
            .store(in: &cancellables)
    }
    
    func endCurrentSession() {
        hasActiveSession = false
        currentSessionRemainingTime = 0
    }
    
    private func performSearch(query: String) {
        isSearching = !query.isEmpty
        
        if query.isEmpty {
            searchResults = []
            return
        }
        
        // Perform case-insensitive search on both title and subject
        searchResults = dummyTasks.filter { task in
            task.title.localizedCaseInsensitiveContains(query) ||
            task.subject.localizedCaseInsensitiveContains(query)
        }
    }
}

// MARK: - Search Result Model
struct SearchResult: Identifiable {
    let id: String
    let title: String
    let subject: String
    let dueDate: Date
    let priority: TaskPriority
}

enum TaskPriority {
    case low
    case medium
    case high
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
} 