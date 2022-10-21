//
//  DateFormatter+Extensions.swift
//  Meetings
//
//  Created by Marco Abundo on 2/3/21.
//

import Foundation

extension DateFormatter {

    private struct CachedFormatters {
        static var mediumDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.dateFormat = .none
            return formatter
        }()
    }

    /// Shared instance of the date formatter with short date format
    static var mediumStyleDateFormatter: DateFormatter = {
        return CachedFormatters.mediumDateFormatter
    }()
}
