//
//  NSDate+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension NSDate {

    public class func dateFromISOString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        return dateFormatter.dateFromString(string)!
    }

    func daysFromNow(days: Double) -> NSDate {
        let daysFromNow: NSTimeInterval = 60 * 60 * 24 * days

        return NSDate().dateByAddingTimeInterval(daysFromNow)
    }

    func daysFromDate(days: Double) -> NSDate {
        let daysFromDate: NSTimeInterval = 60 * 60 * 24 * days

        return self.dateByAddingTimeInterval(daysFromDate)
    }
}
