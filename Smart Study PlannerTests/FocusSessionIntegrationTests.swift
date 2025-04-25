import XCTest
@testable import Smart_Study_Planner

class FocusSessionIntegrationTests: XCTestCase {
    var viewModel: DashboardViewModel!
    var mockFocusStateManager: MockFocusStateManager!
    
    override func setUp() {
        super.setUp()
        
        // Create a mock focus state manager
        mockFocusStateManager = MockFocusStateManager()
        mockFocusStateManager.authorizationResult = true
        mockFocusStateManager.enableFocusResult = true
        mockFocusStateManager.disableFocusResult = true
        
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Create the view model
        viewModel = DashboardViewModel()
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
    
    override func tearDown() {
        viewModel = nil
        mockFocusStateManager = nil
        super.tearDown()
    }
    
    func testFocusSessionStartsDND() {
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is enabled
        XCTAssertTrue(viewModel.isDNDEnabled)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
    
    func testFocusSessionEndsDND() {
        // Replace the shared instance with our mock
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
    
    func testFocusSessionTimerEndsDND() {
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Set a very short focus time for testing
        viewModel.estimatedFocusTime = 1
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is enabled
        XCTAssertTrue(viewModel.isDNDEnabled)
        
        // Wait for the timer to end
        let expectation = XCTestExpectation(description: "Timer should end")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
            // Verify DND is disabled
            XCTAssertFalse(self.viewModel.isDNDEnabled)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
    
    func testEndCurrentSessionDisablesDND() {
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is enabled
        XCTAssertTrue(viewModel.isDNDEnabled)
        
        // End the session
        viewModel.endCurrentSession()
        
        // Verify DND is disabled
        XCTAssertFalse(viewModel.isDNDEnabled)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
    
    func testDNDFailureHandling() {
        // Replace the shared instance with our mock
        let originalManager = FocusStateManager.shared
        FocusStateManager.shared = mockFocusStateManager
        
        // Set the mock to fail when enabling focus
        mockFocusStateManager.enableFocusResult = false
        
        // Start focus mode
        viewModel.toggleFocusMode()
        
        // Verify DND is not enabled due to failure
        XCTAssertFalse(viewModel.isDNDEnabled)
        
        // Restore original manager
        FocusStateManager.shared = originalManager
    }
} 