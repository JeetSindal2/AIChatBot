//
//  ChatViewModelTests.swift
//  DemoChatAppTests
//
//  Created by Jeet Sindal on 16/01/26.
//

import XCTest
@testable import DemoChatApp

@MainActor
final class ChatViewModelTests: XCTestCase {
    var viewModel: (any ChatViewModelProtocol)?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ChatViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitialMessage() {
        XCTAssertEqual(viewModel?.chats.count, 1)
        XCTAssertEqual(viewModel?.chats.first?.message, "Welcome! How may I help you?")
        XCTAssertTrue(viewModel?.chats.first?.isCurrentUser ==  false)
    }
    
    func testAddMessage() {
        viewModel?.addMessage(message: "Hi!", isCurrentUser: true)
        
        XCTAssertEqual(viewModel?.chats.count, 2)
        XCTAssertEqual(viewModel?.chats.last?.message, "Hi!")
        XCTAssertTrue(viewModel?.chats.last?.isCurrentUser ?? false)
    }
    
    func testReplyMessage() async {
        viewModel?.addMessage(message: "Hi!", isCurrentUser: true)

        await viewModel?.replyWithDelayOfFewSeconds()

        XCTAssertTrue(viewModel?.isResponseLoading == false)
        XCTAssertEqual(viewModel?.chats.count, 3)
        XCTAssertNotNil(viewModel?.chats.last?.message)
        XCTAssertTrue(viewModel?.chats.last?.isCurrentUser == false)
    }
}
