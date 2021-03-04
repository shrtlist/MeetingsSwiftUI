//
//  EKEvent+Extension.swift
//  EventKit.Example
//
//  Created by Marco Abundo on 02/15/2021.
//

import Foundation
import EventKit
import SwiftUI

extension EKEvent {

    convenience init(data: Data) {
        self.init(eventStore: EventsRepository.shared.eventStore)
        self.calendar = EventsRepository.shared.selectedCalendars?.first
        self.title = data.title
        self.notes = data.notes
        self.startDate = data.startDate
        self.endDate = data.startDate
        self.isAllDay = true

        var end: EKRecurrenceEnd?

        if data.durationType == DurationType.untilSetEndDate.rawValue {
            end = EKRecurrenceEnd(end: data.recurrenceEndDate)
        } else if data.durationType == DurationType.untilSetNumber.rawValue {
            end = EKRecurrenceEnd(occurrenceCount: data.numberOfMeetings)
        }

        let recurrenceRule = EKRecurrenceRule(recurrenceWith: data.frequency, interval: 1, end: end)

        self.addRecurrenceRule(recurrenceRule)
    }
    
    var color: Color {
        return calendar.color
    }

    var nextOccurrenceDate: Date? {
        guard let recurrenceRule = recurrenceRules?.first,
              let occurrenceDate = occurrenceDate else { return nil }

        var comp = Calendar.Component.month

        switch recurrenceRule.frequency {
        case .daily:
            comp = .day
        case .weekly:
            comp = .weekday
        case .monthly:
            comp = .month
        case .yearly:
            comp = .year
        @unknown default:
            fatalError()
        }

        let interval = recurrenceRule.interval
        return Calendar.current.date(byAdding: comp, value: interval, to: occurrenceDate)
    }
}

extension EKEvent {

    convenience init(title: String, startDate: Date, notes: String, recurrenceRule: EKRecurrenceRule) {
        self.init(eventStore: EventsRepository.shared.eventStore)
        self.calendar = EventsRepository.shared.selectedCalendars?.first
        self.title = title
        self.notes = notes
        self.startDate = startDate
        self.endDate = startDate
        self.isAllDay = true
        self.addRecurrenceRule(recurrenceRule)
    }

    static let someDateTime = Date(timeIntervalSinceReferenceDate: -123456789.0)
    static let recurrenceRule = EKRecurrenceRule(recurrenceWith: .yearly, interval: 1, end: EKRecurrenceEnd(occurrenceCount: 1))

    static let data: [EKEvent] = [
        EKEvent(title: "Jimbo Hawkmeister", startDate: someDateTime, notes: "Jim", recurrenceRule: recurrenceRule),
        EKEvent(title: "Melissa Munrow", startDate: someDateTime, notes: "Mell", recurrenceRule: recurrenceRule),
        EKEvent(title: "Ivan Denisovich", startDate: someDateTime, notes: "Ivan", recurrenceRule: recurrenceRule)
    ]
}

extension EKEvent {
    struct Data {
        var title: String = ""
        var notes: String = ""
        var frequency: EKRecurrenceFrequency = .yearly
        var startDate = Date()
        var durationType = DurationType.indefinitely.rawValue
        var recurrenceEndDate = Date()
        var numberOfMeetings = 1
    }

    var data: Data {
        var frequency: EKRecurrenceFrequency = .yearly
        var durationType = DurationType.indefinitely.rawValue
        var recurrenceEndDate = Date()
        var numberOfMeetings = 1

        if let recurrenceRule = recurrenceRules?.first {
            frequency = recurrenceRule.frequency

            if let recurrenceEnd = recurrenceRule.recurrenceEnd {
                numberOfMeetings = recurrenceEnd.occurrenceCount

                if let endDate = recurrenceEnd.endDate {
                    recurrenceEndDate = endDate
                }

                if numberOfMeetings > 0 {
                    durationType = DurationType.untilSetNumber.rawValue
                } else {
                    durationType = DurationType.untilSetEndDate.rawValue
                }
            }
        }

        return Data(title: title, notes: notes ?? "", frequency: frequency, startDate: startDate, durationType: durationType, recurrenceEndDate: recurrenceEndDate, numberOfMeetings: numberOfMeetings)
    }

    func update(from data: Data) {
        title = data.title
        startDate = data.startDate
        notes = data.notes

        if let rule = recurrenceRules?.first {
            removeRecurrenceRule(rule)
        }

        var end: EKRecurrenceEnd?

        if data.durationType == DurationType.untilSetEndDate.rawValue {
            end = EKRecurrenceEnd(end: data.recurrenceEndDate)
        } else if data.durationType == DurationType.untilSetNumber.rawValue {
            end = EKRecurrenceEnd(occurrenceCount: data.numberOfMeetings)
        }

        let rule = EKRecurrenceRule(recurrenceWith: data.frequency, interval: 1, end: end)

        addRecurrenceRule(rule)
    }
}
