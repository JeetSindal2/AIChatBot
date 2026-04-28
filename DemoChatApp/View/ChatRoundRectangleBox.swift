//
//  ChatRoundRectangleBox.swift
//  DemoChatApp
//
//  Created by Jeet Sindal on 14/01/26.
//

import SwiftUI

/// A single chat bubble view that renders a message with alignment and styling based on the sender.
struct ChatRoundRectangleBox: View {
    /// The chat message to display.
    let chat: ChatModel
    
    /// Background color for the bubble. Green for current user, light gray for others.
    private var backgroundColor: Color {
        chat.isCurrentUser ? Color(.systemGreen) : Color(.systemGray6)
    }
    
    var body: some View {
        // Horizontal layout: optional spacer for alignment, message bubble, and trailing spacer for the other side
        HStack {
            // Right-align current user's messages by inserting a leading spacer
            if chat.isCurrentUser {
                Spacer() // Added Spacer to right align the message
            }
            // Message bubble styling: padding, background, rounded corners, shadow, and flexible height
            Text(chat.message)
                .padding(10)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(10)
                .shadow(radius: 5)
                .fixedSize(horizontal: false, vertical: true)
            
            // Left-align other users' messages by inserting a trailing spacer
            if chat.isCurrentUser == false {
                Spacer() // Added Spacer to left align the message
            }
        }
    }
}

#Preview {
    ChatRoundRectangleBox(chat: ChatModel())
}
