//
//  DemoChatAppUITests.swift
//  DemoChatAppUITests
//
//  Created by Jeet Sindal on 14/01/26.
//

import XCTest

@MainActor
final class DemoChatAppUITests: XCTestCase {
    
    var app: XCUIApplication?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        app?.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testChatScreenLoads() {
        XCTAssertTrue(app?.textFields["messageTextField"].exists ?? false)
        XCTAssertTrue(app?.buttons["sendButton"].exists ?? false)
    }
    
    func testSendButtonDisable() {
        let sendButton = app?.buttons["sendButton"]
        XCTAssertFalse(sendButton?.isEnabled ?? false)
    }
    
    func testSendMessage() {
        let textField = app?.textFields["messageTextField"]
        let sendButton = app?.buttons["sendButton"]
        
        textField?.tap()
        textField?.typeText("Hello")
        
        XCTAssertTrue(sendButton?.isEnabled ?? false)
        
        sendButton?.tap()
        
        XCTAssertTrue(textField?.placeholderValue as? String == "Enter message")
        XCTAssertTrue(textField?.title as? String == "")
    }
}
