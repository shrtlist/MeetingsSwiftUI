//
//  EKRecurrenceRule+Extensions.swift
//  Meetings
//
//  Created by Marco Abundo on 2/15/21.
//

import Foundation
import EventKit

extension EKRecurrenceRule {
    var durationType: DurationType {
        guard let recurrenceEnd = recurrenceEnd else { return .indefinitely}
        return recurrenceEnd.endDate == nil ? .untilSetNumber : .untilSetEndDate
    }
}

enum DurationType: Int, CaseIterable {
    case indefinitely
    case untilSetEndDate
    case untilSetNumber

    public static var allCases: [DurationType] {
        return [.indefinitely, .untilSetEndDate, .untilSetNumber]
    }
}

extension DurationType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .indefinitely: return "Indefinitely"
        case .untilSetEndDate: return "Until a set end date"
        case .untilSetNumber: return "Until a set number of meetings"
        }
    }
}
