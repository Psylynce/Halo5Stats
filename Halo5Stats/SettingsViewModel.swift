//
//  SettingsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SettingsViewModel {

    struct K {
        static let appStoreUrlKey = "appStoreUrl"
        static let appId = "1149670664"
    }

    enum Row {
        case changeDefault
        case review

        var name: String {
            switch self {
            case .changeDefault:
                return "Change Default Gamertag"
            case .review:
                return "Review H5S"
            }
        }
    }

    var rows: [Row] = [.changeDefault, .review]

    var legalText: String {
        let myName = "Justin Powell"
        let today = NSDate()
        let currentYear = NSCalendar.currentCalendar().component(.Year, fromDate: today)

        let legalText = "This application is offered by \(myName), which is solely responsible for its content. It is not sponsored or endorsed by Microsoft. This application uses the Halo® Game Data API. Halo © \(currentYear) Microsoft Corporation. All rights reserved. Microsoft, Halo, and the Halo Logo are trademarks of the Microsoft group of companies.\n\n"

        let madeByText = "App design by Beard diful.\nDeveloped by Psylynce."
        let finalText = legalText + madeByText

        return finalText
    }

    var appReviewUrl: NSURL? {
        guard let urlString = appStoreUrlString else { return nil }
        return NSURL(string: urlString)
    }

    var version: String? {
        if let info = NSBundle.mainBundle().infoDictionary, version = info["CFBundleShortVersionString"] {
            return "v \(version)"
        } else {
            return nil
        }
    }

    private var appStoreUrlString: String? {
        get {
            return NSUserDefaults.standardUserDefaults().stringForKey(K.appStoreUrlKey) ?? "https://itunes.apple.com/app/id\(K.appId)"
        }
        set {
            if newValue != appStoreUrlString {
                NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: K.appStoreUrlKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }

    private func updateAppStoreUrl() {
        guard let url = NSURL(string: "") else { return }

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { [weak self] (data, response, error) in
            guard let data = data where error == nil else { return }

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
                self?.parseConfig(json)
            } catch {
                return
            }
        }

        task.resume()
    }

    private func parseConfig(json: [String: AnyObject]?) {
        guard let json = json else { return }

        if let urlValue = json[K.appStoreUrlKey] as? String {
            appStoreUrlString = urlValue
        }
    }
}
