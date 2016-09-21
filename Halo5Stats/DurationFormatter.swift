//
//  DurationFormatter.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class DurationFormatter {

    enum Delimeter: String {
        case Start = "P"
        case Time = "T"
        case Days = "D"
        case Hours = "H"
        case Minutes = "M"
        case Seconds = "S"
    }

    static func interval(forDuration duration: String) -> NSTimeInterval {
        var days = ""
        var hours = ""
        var minutes = ""
        var seconds = ""
        var totalSeconds: Double = 0

        if duration.characters.count == 0 {
            return 0
        }

        var clean = duration.componentsSeparatedByString(Delimeter.Start.rawValue)[1]

        if clean.containsString(Delimeter.Days.rawValue) {
            days = clean.componentsSeparatedByString(Delimeter.Days.rawValue)[0]
            clean = clean.componentsSeparatedByString(Delimeter.Days.rawValue)[1]
            if let daysDouble = Double(days) {
                totalSeconds += daysDouble * 24 * 60 * 60
            }
        }

        clean = clean.componentsSeparatedByString(Delimeter.Time.rawValue)[1]

        if clean.containsString(Delimeter.Hours.rawValue) {
            hours = clean.componentsSeparatedByString(Delimeter.Hours.rawValue)[0]
            clean = clean.componentsSeparatedByString(Delimeter.Hours.rawValue)[1]
            if let hourDouble = Double(hours) {
                totalSeconds += hourDouble * 60 * 60
            }
        }

        if clean.containsString(Delimeter.Minutes.rawValue) {
            minutes = clean.componentsSeparatedByString(Delimeter.Minutes.rawValue)[0]
            clean = clean.componentsSeparatedByString(Delimeter.Minutes.rawValue)[1]
            if let minutesDouble = Double(minutes) {
                totalSeconds += minutesDouble * 60
            }
        }

        if clean.containsString(Delimeter.Seconds.rawValue) {
            seconds = clean.componentsSeparatedByString(Delimeter.Seconds.rawValue)[0]
            if let secondsDouble = Double(seconds) {
                totalSeconds += secondsDouble
            }
        }

        return Double(totalSeconds)
    }

    static func readableDuration(duration: String) -> String? {
        let i = interval(forDuration: duration)

        let formatter = NSDateComponentsFormatter()
        return formatter.stringFromTimeInterval(i)
    }

}