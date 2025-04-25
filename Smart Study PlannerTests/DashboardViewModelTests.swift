import XCTest
import Combine
@testable import Smart_Study_Planner

class DashboardViewModelTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = DashboardViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Focus Mode Tests
    
    func testToggleFocusMode() {
        // Initial state
        XCTAssertFalse(viewModel.isFocusModeEnabled)
        XCTAssertFalse(viewModel.isDNDEnabled)
        
        // Toggle on
        viewModel.toggleFocusMode()
        XCTAssertTrue(viewModel.isFocusModeEnabled)
        XCTAssertTrue(viewModel.hasActiveSession)
        XCTAssertEqual(viewModel.currentSessionRemainingTime, viewModel.estimatedFocusTime)
        
        // Toggle off
        viewModel.toggleFocusMode()
        XCTAssertFalse(viewModel.isFocusModeEnabled)
        XCTAssertFalse(viewModel.hasActiveSession)
        XCTAssertEqual(viewModel.currentSessionRemainingTime, 0)
    }
    
    func testFocusSessionTimer() {
        // Start a focus session
        viewModel.toggleFocusMode()
        
        // Create expectation for timer completion
        let expectation = XCTestExpectation(description: "Timer should count down")
        
        // Wait for a short time to allow timer to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Verify timer has started counting down
            XCTAssertLessThan(self.viewModel.currentSessionRemainingTime, self.viewModel.estimatedFocusTime)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
    }
    
    func testEndCurrentSession() {
        // Start a focus session
        viewModel.toggleFocusMode()
        XCTAssertTrue(viewModel.hasActiveSession)
        
        // End the session
        viewModel.endCurrentSession()
        XCTAssertFalse(viewModel.hasActiveSession)
        XCTAssertEqual(viewModel.currentSessionRemainingTime, 0)
        XCTAssertFalse(viewModel.isDNDEnabled)
    }
    
    // MARK: - Search Tests
    
    func testSearchEmptyQuery() {
        // Initial state
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        
        // Set empty query
        viewModel.searchQuery = ""
        
        // Wait for debounce
        let expectation = XCTestExpectation(description: "Search should clear results")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertFalse(self.viewModel.isSearching)
            XCTAssertTrue(self.viewModel.searchResults.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testSearchWithQuery() {
        // Set search query
        viewModel.searchQuery = "Math"
        
        // Wait for debounce
        let expectation = XCTestExpectation(description: "Search should return results")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertTrue(self.viewModel.isSearching)
            XCTAssertFalse(self.viewModel.searchResults.isEmpty)
            
            // Verify search results contain "Math"
            let hasMathResult = self.viewModel.searchResults.contains { result in
                result.title.contains("Math") || result.subject.contains("Math")
            }
            XCTAssertTrue(hasMathResult)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - DND Mode Tests
    
    func testDNDModeEnabled() {
        // Mock FocusStateManager to always return success
        let mockFocusStateManager = MockFocusStateManager()
        mockFocusStateManager.authorizationResult = true
        mockFocusStateManager.enableFocusResult = true
        mockFocusStateManager.disableFocusResult = true
        
        // Replace the shared instance with our mock
        // Note: In a real app, you would use dependency injection
        // This is a workaround for testing
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is enabled
        XCTAssertTrue(viewModel.isDNDEnabled)
        
        // End focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is disabled
        XCTAssertFalse(viewModel.isDNDEnabled)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
    
    func testDNDModeAuthorizationDenied() {
        // Mock FocusStateManager to deny authorization
        let mockFocusStateManager = MockFocusStateManager()
        mockFocusStateManager.authorizationResult = false
        
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is not enabled due to authorization denial
        XCTAssertFalse(viewModel.isDNDEnabled)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
}

// MARK: - Mock FocusStateManager

class MockFocusStateManager: FocusStateManager {
    var authorizationResult: Bool = true
    var enableFocusResult: Bool = true
    var disableFocusResult: Bool = true
    
    override func requestAuthorization(completion: @escaping (Bool) -> Void) {
        completion(authorizationResult)
    }
    
    override func enableFocus(for activity: FocusActivity, completion: @escaping (Bool) -> Void) {
        completion(enableFocusResult)
    }
    
    override func disableFocus(completion: @escaping (Bool) -> Void) {
        completion(disableFocusResult)
    }
} 