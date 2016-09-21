//
//  UIFont+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

extension UIFont {

    enum KelsonWeight: String {
        case ExtraBold = "ExtraBold"
        case Bold = "Bold"
        case Medium = "Medium"
        case Regular = ""
        case Light = "Light"
        case Thin = "Thin"
    }

    static func kelson(weight: KelsonWeight, size: CGFloat) -> UIFont? {
        if weight == .Regular {
            return UIFont(name: "Kelson", size: size)
        }
        return UIFont(name: "Kelson-\(weight.rawValue)", size: size)
    }
}
