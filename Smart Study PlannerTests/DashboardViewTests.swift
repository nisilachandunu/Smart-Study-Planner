import XCTest
import SwiftUI
@testable import Smart_Study_Planner

class DashboardViewTests: XCTestCase {
    func testFocusModeCard() {
        // Create a view model
        let viewModel = DashboardViewModel()
        
        // Test with focus mode disabled
        let disabledCard = FocusModeCard(
            isEnabled: .constant(false),
            estimatedTime: 1800,
            isDNDEnabled: false,
            onToggle: {}
        )
        
        // Test with focus mode enabled
        let enabledCard = FocusModeCard(
            isEnabled: .constant(true),
            estimatedTime: 1800,
            isDNDEnabled: true,
            onToggle: {}
        )
        
        // Test with focus mode enabled but DND disabled
        let enabledNoDNDCard = FocusModeCard(
            isEnabled: .constant(true),
            estimatedTime: 1800,
            isDNDEnabled: false,
            onToggle: {}
        )
        
        // These tests just ensure the views can be created without crashing
        // In a real app, you would use ViewInspector or similar to test the view hierarchy
        XCTAssertNotNil(disabledCard)
        XCTAssertNotNil(enabledCard)
        XCTAssertNotNil(enabledNoDNDCard)
    }
    
    func testCurrentSessionCard() {
        // Create a current session card
        let card = CurrentSessionCard(
            remainingTime: 1800,
            onEnd: {}
        )
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(card)
    }
    
    func testDashboardView() {
        // Create a dashboard view
        let view = DashboardView()
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(view)
    }
    
    func testSearchBar() {
        // Create a search bar
        let searchBar = DashboardSearchBar(text: .constant(""))
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(searchBar)
    }
    
    func testSearchResultsView() {
        // Create search results
        let results = [
            SearchResult(id: "1", title: "Test Task", subject: "Test Subject", dueDate: Date(), priority: .high)
        ]
        
        // Create a search results view
        let view = SearchResultsView(results: results)
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(view)
    }
    
    func testNextSessionCard() {
        // Create a next session
        let session = StudySession(
            sessionID: "1",
            taskID: "task1",
            startTime: Date().addingTimeInterval(3600),
            endTime: Date().addingTimeInterval(7200),
            duration: 3600
        )
        
        // Create a next session card with session
        let cardWithSession = NextSessionCard(session: session)
        
        // Create a next session card without session
        let cardWithoutSession = NextSessionCard(session: nil)
        
        // These tests just ensure the views can be created without crashing
        XCTAssertNotNil(cardWithSession)
        XCTAssertNotNil(cardWithoutSession)
    }
    
    func testWeeklyProgressCard() {
        // Create weekly progress data
        let progressData = [
            ("Mon", 2.5),
            ("Tue", 3.0),
            ("Wed", 1.5)
        ]
        
        // Create a weekly progress card
        let card = WeeklyProgressCard(progressData: progressData)
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(card)
    }
    
    func testNotificationsCard() {
        // Create notifications
        let notifications = [
            NotificationItem(
                id: "1",
                message: "Test notification",
                timestamp: Date(),
                isRead: false,
                type: .sessionReminder
            )
        ]
        
        // Create a notifications card
        let card = NotificationsCard(notifications: notifications)
        
        // This test just ensures the view can be created without crashing
        XCTAssertNotNil(card)
    }
} 