//
//  DateFormatter.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

enum DateFormat: String {
    case MonthDayYear = "MM/dd/yyyy"
}

class DateFormatter {

    static let formatter = Foundation.DateFormatter()

    static func string(fromDate date: Date, format: DateFormat) -> String {
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone.autoupdatingCurrent
        let dateString = formatter.string(from: date)
        return dateString
    }
}
