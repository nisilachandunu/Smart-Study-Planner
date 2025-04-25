//
//  Smart_Study_PlannerApp.swift
//  Smart Study Planner
//
//  Created by Nisila on 2025-03-07.
//

import SwiftUI

@main
struct Smart_Study_PlannerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
