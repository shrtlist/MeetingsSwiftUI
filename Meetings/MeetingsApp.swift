//
//  MeetingsApp.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import SwiftUI

@main
struct MeetingsApp: App {
    @StateObject private var data = EventsRepository.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(events: $data.events)
            }
        }
    }
}
