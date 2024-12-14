//
//  MatchAssignmentApp.swift
//  MatchAssignment
//
//  Created by NIKTE Mayuri on 14/12/24.
//

import SwiftUI

@main
struct MatchAssignmentApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MatchListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
