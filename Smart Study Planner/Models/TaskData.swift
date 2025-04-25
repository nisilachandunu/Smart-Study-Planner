//
//  TaskData.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-21.
//

import Foundation

// Represents a study task that the user needs to complete
struct StudyTask: Identifiable, Codable {
    var id: String { taskID }
    var taskID: String
    var userID: String
    var title: String
    var subject: String
    var deadline: Date
    var priority: Int
    var status: String
    var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case taskID = "task_id"
        case userID = "user_id"
        case title
        case subject
        case deadline
        case priority
        case status
        case notes
    }
}

// Represents a recorded study session for tracking progress
struct StudySession: Identifiable, Codable {
    var id: String { sessionID }
    var sessionID: String
    var taskID: String
    var startTime: Date
    var endTime: Date
    var duration: Double
    
    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case taskID = "task_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case duration
    }
}

// Represents an achievement earned by the user, supporting productivity streaks
struct Achievement: Identifiable, Codable {
    var id: String { achievementID }
    var achievementID: String
    var userID: String
    var title: String
    var description: String
    var dateAchieved: Date
    
    enum CodingKeys: String, CodingKey {
        case achievementID = "achievement_id"
        case userID = "user_id"
        case title
        case description
        case dateAchieved = "date_achieved"
    }
}

// Represents a study location for the location finder feature
struct StudyLocation: Identifiable, Codable {
    var id: String { locationID }
    var locationID: String
    var name: String
    var latitude: Double
    var longitude: Double
    var rating: Double?
    var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case locationID = "location_id"
        case name
        case latitude
        case longitude
        case rating
        case notes
    }
}

// Represents the state of an AR-based study timer (transient, not persisted)
struct ARTimer {
    var duration: TimeInterval
    var remainingTime: TimeInterval
    var isRunning: Bool
    var associatedTaskID: String?  
}
