//
//  UIColor+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32

        switch hex.count {
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

    convenience private init(haloColor: HaloColor) {
        self.init(hex: haloColor.rawValue)
    }

    enum HaloColor: String {
        case arenaAccent = "00deff"
        case warzoneAccent = "ffb503"
        case customAccent = "7f59eb"
        case black = "111111"
        case nero = "1e1e1e"
        case curiousBlue = "448ccb"
        case whiteSmoke = "ececec"
        case cinder = "1e2327"
        case midnight = "1e3037"
        case elephant = "22353c"
        case bismark = "446A78"
        case springGreen = "00ff90"
        case blueCharcoal = "282c33"
        case standardWeapons = "273744"
        case powerWeapons = "2e3e42"
        case vehicles = "26292f"
        case grenades = "3c3e41"
        case turrets = "353031"
        case unknown = "2f2e39"
    }

    func lighter(_ amount: CGFloat = 0.25) -> UIColor {
        return hue(withBrightnessAmount: 1 + amount)
    }

    func darker(_ amount: CGFloat = 0.25) -> UIColor {
        return hue(withBrightnessAmount: 1 - amount)
    }

    fileprivate func hue(withBrightnessAmount amount: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        }

        return self
    }

    // MARK: Static

    static var arenaAccent: UIColor {
        return UIColor(haloColor: .arenaAccent)
    }

    static var warzoneAccent: UIColor {
        return UIColor(haloColor: .warzoneAccent)
    }

    static var customAccent: UIColor {
        return UIColor(haloColor: .customAccent)
    }

    static var haloBlack: UIColor {
        return UIColor(haloColor: .black)
    }

    static var nero: UIColor {
        return UIColor(haloColor: .nero)
    }

    static var curiousBlue: UIColor {
        return UIColor(haloColor: .curiousBlue)
    }

    static var whiteSmoke: UIColor {
        return UIColor(haloColor: .whiteSmoke)
    }

    static var cinder: UIColor {
        return UIColor(haloColor: .cinder)
    }

    static var midnight: UIColor {
        return UIColor(haloColor: .midnight)
    }

    static var elephant: UIColor {
        return UIColor(haloColor: .elephant)
    }

    static var bismark: UIColor {
        return UIColor(haloColor: .bismark)
    }

    static var springGreen: UIColor {
        return UIColor(haloColor: .springGreen)
    }

    static var blueCharcoal: UIColor {
        return UIColor(haloColor: .blueCharcoal)
    }

    static var standardWeapons: UIColor {
        return UIColor(haloColor: .standardWeapons)
    }

    static var powerWeapons: UIColor {
        return UIColor(haloColor: .powerWeapons)
    }

    static var vehicles: UIColor {
        return UIColor(haloColor: .vehicles)
    }

    static var grenades: UIColor {
        return UIColor(haloColor: .grenades)
    }

    static var turrets: UIColor {
        return UIColor(haloColor: .turrets)
    }

    static var unknown: UIColor {
        return UIColor(haloColor: .unknown)
    }
}
