//
//  ChatViewModel.swift
//  DemoChatApp
//
//  Created by Jeet Sindal on 15/01/26.
//

/// View model responsible for managing chat messages and simulating AI responses.

import Foundation
import FoundationModels
import Combine

/// Abstraction for a chat view model that manages messages and sending behavior.
protocol ChatViewModelProtocol: ObservableObject {
    /// List of chat messages displayed in the UI.
    var chats: [ChatModel] { get set }
    /// Adds a new message to the chat.
    /// - Parameters:
    ///   - message: The message text to add.
    ///   - isCurrentUser: Whether the message was sent by the current user.
    
    /// Indicates whether an AI response is currently being prepared.
    var isResponseLoading: Bool { get set }
    
    func addMessage(message: String, isCurrentUser: Bool)
    
    /// Reply a message after delay of few seconds
    func replyWithDelayOfFewSeconds() async
}

/// Main-actor isolated implementation of the chat view model.
/// Ensures all UI-bound state updates occur on the main thread.
@MainActor
class ChatViewModel: ChatViewModelProtocol {
    
    /// All chat messages in chronological order. Initialized with a placeholder 'Welcome' message.
    @Published var chats: [ChatModel] = [ChatModel()]
    
    /// Indicates whether an AI response is currently being prepared.
    @Published var isResponseLoading: Bool = false
    
    /// Session that streams responses from the on-device language model.
    private var languageModelSession: LanguageModelSession
    
    init (languageModelSession: LanguageModelSession = LanguageModelSession()) {
        self.languageModelSession = languageModelSession
    }
    
    /// Appends a message to the list and triggers an AI reply if the sender is the current user.
    /// - Parameters:
    ///   - message: The message body.
    ///   - isCurrentUser: True if the message is from the current user.
    func addMessage(message: String, isCurrentUser: Bool) {
        chats.append(ChatModel(message: message, isCurrentUser: isCurrentUser, date: Date()))
    }
    
    /// Starts a short delay before generating an AI reply.
    /// Sets the loading state, schedules a one-shot timer, and then requests a streamed response.
    func replyWithDelayOfFewSeconds() async {
        do {
            
            defer {
                isResponseLoading = false
            }
            
            guard let lastChat = chats.last(where: {$0.isCurrentUser == true}) else { return }
            
            // Update loading state
            isResponseLoading = true
            try await Task.sleep(nanoseconds: 3000000000) // Delay for 3 seconds
            let response = await replyMessageUsingAI(forMessage: lastChat.message)
            guard let response, response.isEmpty == false else { return }
            addMessage(message: response, isCurrentUser: false)
            
        } catch {
            debugPrint("Error while getting response: \(error.localizedDescription)")
        }
    }
    
    /// Requests a streamed response from the language model and returns the final content.
    /// - Parameter message: The user's prompt.
    /// - Returns: The completed response string, or nil if an error occurs.
    private func replyMessageUsingAI(forMessage message: String) async -> String? {
        do {
            let stream = languageModelSession.streamResponse(to: message)
            
            var finalResponse: String = ""
            // Accumulate only the final content when the stream signals completion
            for try await response in stream {
                if response.rawContent.isComplete {
                    finalResponse = response.content
                }
            }
            return finalResponse
        } catch {
            debugPrint("Error while getting response: \(error.localizedDescription)")
            return nil
        }
    }
}

