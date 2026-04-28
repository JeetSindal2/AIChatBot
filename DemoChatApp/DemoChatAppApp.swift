//
//  DemoChatAppApp.swift
//  DemoChatApp
//
//  Created by Jeet Sindal on 14/01/26.
//

import SwiftUI
import CoreData

@main
struct DemoChatAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ChatView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
