//
//  ChatModel.swift
//  DemoChatApp
//
//  Created by Jeet Sindal on 15/01/26.
//

/// Data model representing a single chat message.

import Foundation

/// Abstraction for a chat message model, used by views and view models.
/// Conforms to `Identifiable` for list rendering and `Equatable` for change detection.
protocol ChatModelProtocol: Identifiable, Equatable {
    /// Unique identifier for the message.
    var id: UUID { get }
    /// The textual content of the message.
    var message: String { get set }
    /// Indicates whether the message was sent by the current user.
    var isCurrentUser: Bool { get set }
    /// Timestamp when the message was created/sent.
    var date: Date { get set }
}

/// Concrete implementation of `ChatModelProtocol` used throughout the app.
struct ChatModel: ChatModelProtocol {
    /// Unique identifier for this message.
    var id: UUID
    /// The message body text.
    var message: String
    /// True if the message originates from the current user (used for UI alignment and styling).
    var isCurrentUser: Bool
    /// Creation timestamp for the message. Not currently used in UI; reserved for future backend integration
    /// (e.g., sorting, grouping, and displaying timestamps).
    var date: Date

    /// Creates a new chat message.
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID).
    ///   - title: Message text (defaults to a welcome prompt).
    ///   - isCurrentUser: Whether the message is from the current user (defaults to false).
    ///   - date: Creation timestamp (defaults to current date/time).
    init(id: UUID = UUID(), message: String = "Welcome! How may I help you?", isCurrentUser: Bool = false, date: Date = Date()) {
        self.id = id
        self.message = message
        self.isCurrentUser = isCurrentUser
        self.date = date
    }
}
