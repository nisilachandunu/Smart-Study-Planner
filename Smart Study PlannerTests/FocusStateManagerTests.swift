import XCTest
@testable import Smart_Study_Planner

class FocusStateManagerTests: XCTestCase {
    var focusStateManager: FocusStateManager!
    
    override func setUp() {
        super.setUp()
        focusStateManager = FocusStateManager()
    }
    
    override func tearDown() {
        focusStateManager = nil
        super.tearDown()
    }
    
    func testRequestAuthorization() {
        // Create expectation for authorization completion
        let expectation = XCTestExpectation(description: "Authorization should complete")
        
        // Request authorization
        focusStateManager.requestAuthorization { granted in
            // In our simulated implementation, authorization is always granted
            XCTAssertTrue(granted)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testEnableFocus() {
        // Create expectation for enable focus completion
        let expectation = XCTestExpectation(description: "Enable focus should complete")
        
        // Create a focus activity
        let activity = FocusActivity(
            name: "Test Focus",
            icon: "test.icon",
            color: .red
        )
        
        // Enable focus
        focusStateManager.enableFocus(for: activity) { success in
            // In our simulated implementation, enabling focus always succeeds
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDisableFocus() {
        // Create expectation for disable focus completion
        let expectation = XCTestExpectation(description: "Disable focus should complete")
        
        // Disable focus
        focusStateManager.disableFocus { success in
            // In our simulated implementation, disabling focus always succeeds
            XCTAssertTrue(success)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
} 