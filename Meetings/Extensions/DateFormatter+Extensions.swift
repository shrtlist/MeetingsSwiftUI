//
//  DateFormatter+Extensions.swift
//  Meetings
//
//  Created by Marco Abundo on 2/3/21.
//

import Foundation

public extension DateFormatter {

    private struct CachedFormatters {
        static var iso8601UTCDateFormatter: ISO8601DateFormatter = {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime,
                                       .withDashSeparatorInDate,
                                       .withFullDate,
                                       .withFractionalSeconds,
                                       .withColonSeparatorInTimeZone]
            return formatter
        }()

        static var mediumDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = .none
            return formatter
        }()
    }

    /// Shared instance of `ISO8601DateFormatter`
    static var iso8601UTCDateFormatter: ISO8601DateFormatter {
        return CachedFormatters.iso8601UTCDateFormatter
    }

    /// Shared instance of the date formatter with short date format
    static var mediumStyleDateFormatter: DateFormatter = {
        return CachedFormatters.mediumDateFormatter
    }()
}
