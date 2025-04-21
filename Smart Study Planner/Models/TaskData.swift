//
//  TaskData.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-04-21.
//

import Foundation

// Represents a study task that the user needs to complete
struct StudyTask {
    var taskID: String
    var userID: String
    var title: String
    var subject: String
    var deadline: Date
    var priority: Int
    var status: String
    var notes: String?
}

// Represents a recorded study session for tracking progress
struct StudySession {
    var sessionID: String
    var taskID: String
    var startTime: Date
    var endTime: Date
    var duration: Double
}

// Represents an achievement earned by the user, supporting productivity streaks
struct Achievement {
    var achievementID: String
    var userID: String
    var title: String
    var description: String
    var dateAchieved: Date
}

// Represents a study location for the location finder feature
struct StudyLocation {
    var locationID: String
    var name: String
    var latitude: Double
    var longitude: Double
    var rating: Double?
    var notes: String?
}

// Represents the state of an AR-based study timer (transient, not persisted)
struct ARTimer {
    var duration: TimeInterval
    var remainingTime: TimeInterval
    var isRunning: Bool
    var associatedTaskID: String?  
}
