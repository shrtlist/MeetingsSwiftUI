//
//  EventsRepository.swift
//  EventKit.Example
//
//  Created by Filip Němeček on 31/07/2020.
//  Copyright © 2020 Filip Němeček. All rights reserved.
//

import Foundation
import EventKit
import SwiftUI
import Combine

typealias Action = () -> ()

final class EventsRepository: ObservableObject {
    static let shared = EventsRepository()
    
    private var subscribers: Set<AnyCancellable> = []
    
    let eventStore = EKEventStore()
    
    @Published var selectedCalendars: Set<EKCalendar>?
    
    @Published var events: [EKEvent] = []
    
    private init() {
        selectedCalendars = loadSelectedCalendars() ?? Set([eventStore.defaultCalendarForNewEvents].compactMap({ $0 }))
        
        $selectedCalendars.sink { [weak self] (calendars) in
            self?.saveSelectedCalendars(calendars)
            self?.loadAndUpdateEvents()
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: .eventsDidChange)
            .sink { [weak self] (notification) in
                self?.loadAndUpdateEvents()
                
            }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { [weak self] (notification) in
                self?.loadAndUpdateEvents()
            }
            .store(in: &subscribers)
    }
    
    private func loadSelectedCalendars() -> Set<EKCalendar>? {
        if let identifiers = UserDefaults.standard.stringArray(forKey: "CalendarIdentifiers") {
            let calendars = eventStore.calendars(for: .event).filter({ identifiers.contains($0.calendarIdentifier) })
            guard !calendars.isEmpty else { return nil }
            return Set(calendars)
        } else {
            return nil
        }
    }
    
    private func saveSelectedCalendars(_ calendars: Set<EKCalendar>?) {
        if let identifiers = calendars?.compactMap({ $0.calendarIdentifier }) {
            UserDefaults.standard.set(identifiers, forKey: "CalendarIdentifiers")
        }
    }
    
    private func loadAndUpdateEvents() {
        loadEvents(completion: { (events) in
            DispatchQueue.main.async {
                self.events = events ?? []
            }
        })
    }
    
    func requestAccess(onGranted: @escaping Action, onDenied: @escaping Action) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                onGranted()
            } else {
                onDenied()
            }
        }
    }
    
    func loadEvents(completion: @escaping (([EKEvent]?) -> Void)) {
        requestAccess(onGranted: {
            let weekFromNow = Date().advanced(by: TimeInterval.week)
            
            let predicate = self.eventStore.predicateForEvents(withStart: Date(), end: weekFromNow, calendars: Array(self.selectedCalendars ?? []))
            
            let events = self.eventStore.events(matching: predicate)
            
            completion(events)
        }) {
            completion(nil)
        }
    }

    func save(_ event: EKEvent) {
        do {
            try eventStore.save(event, span: .futureEvents)
        } catch {
            print("Error saving event: \(error)")
        }
    }
    
    deinit {
        subscribers.forEach { (sub) in
            sub.cancel()
        }
    }
}
