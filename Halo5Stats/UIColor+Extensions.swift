//
//  UIColor+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        let hex = hex.stringByTrimmingCharactersInSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        var int = UInt32()
        NSScanner(string: hex).scanHexInt(&int)
        let a, r, g, b: UInt32

        switch hex.characters.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    convenience init(haloColor: HaloColor) {
        self.init(hex: haloColor.rawValue)
    }

    enum HaloColor: String {
        case ArenaAccent = "00deff"
        case WarzoneAccent = "ffb503"
        case CustomAccent = "7f59eb"
        case Black = "111111"
        case Nero = "1e1e1e"
        case CuriousBlue = "448ccb"
        case WhiteSmoke = "ececec"
        case Cinder = "1e2327"
        case Midnight = "1e3037"
        case Elephant = "22353c"
        case Bismark = "446A78"
        case SpringGreen = "00ff90"
        case blueCharcoal = "282c33"
        case standardWeapons = "273744"
        case powerWeapons = "2e3e42"
        case vehicles = "26292f"
        case grenades = "3c3e41"
        case turrets = "353031"
    }

    func lighter(amount: CGFloat = 0.25) -> UIColor {
        return hue(withBrightnessAmount: 1 + amount)
    }

    func darker(amount: CGFloat = 0.25) -> UIColor {
        return hue(withBrightnessAmount: 1 - amount)
    }

    private func hue(withBrightnessAmount amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        }

        return self
    }
}
