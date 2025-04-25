import Foundation

struct NotificationItem: Identifiable, Codable {
    let id: String
    let message: String
    let timestamp: Date
    let isRead: Bool
    let type: NotificationType
    
    var timeAgo: String {
        // Calculate time ago string
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day], from: timestamp, to: now)
        
        if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
}

enum NotificationType: Codable {
    case sessionReminder
    case deadlineApproaching
    case achievementUnlocked
    case studyStreak
    case newMaterial
    case groupMeeting
    case quizResult
    case custom(String)
    
    private enum CodingKeys: String, CodingKey {
        case type
        case customValue
    }
    
    private enum TypeValue: String, Codable {
        case sessionReminder
        case deadlineApproaching
        case achievementUnlocked
        case studyStreak
        case newMaterial
        case groupMeeting
        case quizResult
        case custom
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(TypeValue.self, forKey: .type)
        
        switch type {
        case .sessionReminder:
            self = .sessionReminder
        case .deadlineApproaching:
            self = .deadlineApproaching
        case .achievementUnlocked:
            self = .achievementUnlocked
        case .studyStreak:
            self = .studyStreak
        case .newMaterial:
            self = .newMaterial
        case .groupMeeting:
            self = .groupMeeting
        case .quizResult:
            self = .quizResult
        case .custom:
            let value = try container.decode(String.self, forKey: .customValue)
            self = .custom(value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .sessionReminder:
            try container.encode(TypeValue.sessionReminder, forKey: .type)
        case .deadlineApproaching:
            try container.encode(TypeValue.deadlineApproaching, forKey: .type)
        case .achievementUnlocked:
            try container.encode(TypeValue.achievementUnlocked, forKey: .type)
        case .studyStreak:
            try container.encode(TypeValue.studyStreak, forKey: .type)
        case .newMaterial:
            try container.encode(TypeValue.newMaterial, forKey: .type)
        case .groupMeeting:
            try container.encode(TypeValue.groupMeeting, forKey: .type)
        case .quizResult:
            try container.encode(TypeValue.quizResult, forKey: .type)
        case .custom(let value):
            try container.encode(TypeValue.custom, forKey: .type)
            try container.encode(value, forKey: .customValue)
        }
    }
} 