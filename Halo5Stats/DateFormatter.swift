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

    static let formatter = NSDateFormatter()

    static func string(fromDate date: NSDate, format: DateFormat) -> String {
        formatter.dateFormat = format.rawValue
        formatter.timeZone = NSTimeZone.localTimeZone()
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
}
