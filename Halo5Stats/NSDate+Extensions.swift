//
//  NSDate+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension Date {

    public static func dateFromISOString(_ string: String) -> Date {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return dateFormatter.date(from: string)!
    }

    func daysFromNow(_ days: Double) -> Date {
        let daysFromNow: TimeInterval = 60 * 60 * 24 * days

        return Date().addingTimeInterval(daysFromNow)
    }

    func daysFromDate(_ days: Double) -> Date {
        let daysFromDate: TimeInterval = 60 * 60 * 24 * days

        return self.addingTimeInterval(daysFromDate)
    }
}
