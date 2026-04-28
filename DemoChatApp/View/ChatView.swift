//
//  ChatView.swift
//  DemoChatApp
//
//  Created by Jeet Sindal on 14/01/26.
//

import SwiftUI
import Combine

/// A simple chat screen demonstrating a message list, input bar, and an AI-simulated reply flow.
struct ChatView: View {
    
    /// View model that holds chat messages and business logic, including simulated AI responses.
    @StateObject private var viewModel = ChatViewModel() 
    
    /// The text currently entered in the message input field.
    @State private var newMessage: String = "" 
    
    /// Tracks focus state of the input field to control keyboard dismissal.
    @FocusState private var messageIsFocused: Bool 
    
    var body: some View {
        // Main vertical layout: header, message list with auto-scroll, and input bar
        VStack {
            // Header title
            Text("Demo Chat App")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // ScrollViewReader enables programmatic scrolling to the latest message
            ScrollViewReader { proxy in
                // Scrollable area for the chat messages
                ScrollView {
                    // Use LazyVStack for efficient rendering of large lists
                    // Spacing controls vertical space between message bubbles
                    LazyVStack(spacing: 10) { 
                        // Render each chat message as a rounded rectangle bubble
                        ForEach(viewModel.chats) { chat in
                            ChatRoundRectangleBox(chat: chat)
                                .id(chat.id) // Assign this view a unique id so ScrollViewReader can scroll to this exact message.
                        }
                    }
                    .padding()
                }
                // When messages change, scroll to the newest one to keep the latest in view
                .onChange(of: viewModel.chats) { _ , newValue in
                    if let lastId = newValue.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input bar: text field and Send button
            HStack {
                // Text field where user composes a new message
                TextField("Enter message", text: $newMessage)
                    .accessibilityIdentifier("messageTextField")
                    .focused($messageIsFocused)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Sends the message and clears the input
                Button("Send") {
                    viewModel.addMessage(message: newMessage, isCurrentUser: true)
                    // Clear the input after sending
                    newMessage = ""
                    Task {
                        await viewModel.replyWithDelayOfFewSeconds()
                    }
                }
                .accessibilityIdentifier("sendButton")
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.green) // sets the prominent fill color
                .disabled(newMessage.isEmpty)
            }
            .padding(.horizontal, 10)
        }
        // Show a loading indicator while the AI response is being prepared
        .overlay(content: {
            if viewModel.isResponseLoading {
                // Non-blocking progress indicator
                ProgressView("Loading...")
                    .progressViewStyle(.circular)
            }
        })
        // Dismiss the keyboard when tapping outside the input field
        .onTapGesture {
            messageIsFocused = false // Dismiss the keyboard on Tap
        }
    }
}

#Preview {
    ChatView()
}

