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
                MeetingsView(events: $data.events)
            }
            .onAppear {
                data.loadEvents(completion: { events in
                    print("Loaded events")
                })
            }
        }
    }
}
