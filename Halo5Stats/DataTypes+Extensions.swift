//
//  DataTypes+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension Double {

    func roundToPlaces(places: Int) -> Double {
        guard !isNaN && !isInfinite else { return 0 }
        let divisor = pow(10.0, Double(places))
        let int = Int(self * divisor)
        return Double(int) / divisor
    }

    func roundedToTwo() -> Double {
        return self.roundToPlaces(2)
    }

    var cleanValue: String {
        return self % 1 == 0 ? String(format: "%.0f", self) : String(self)
    }
}
