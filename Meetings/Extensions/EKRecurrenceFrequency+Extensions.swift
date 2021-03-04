//
//  EKRecurrenceFrequency+Extensions.swift
//  Meetings
//
//  Created by Marco Abundo on 2/4/21.
//

import Foundation
import EventKit

extension EKRecurrenceFrequency: CaseIterable {
    public static var allCases: [EKRecurrenceFrequency] {
        return [.daily, .weekly, .monthly, .yearly]
    }
}

extension EKRecurrenceFrequency: CustomStringConvertible {
    public var description: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        @unknown default:
            fatalError()
        }
    }
}
