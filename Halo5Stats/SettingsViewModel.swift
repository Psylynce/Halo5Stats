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
        let today = Date()
        let currentYear = (Calendar.current as NSCalendar).component(.year, from: today)

        let legalText = "This application is offered by \(myName), which is solely responsible for its content. It is not sponsored or endorsed by Microsoft. This application uses the Halo® Game Data API. Halo © \(currentYear) Microsoft Corporation. All rights reserved. Microsoft, Halo, and the Halo Logo are trademarks of the Microsoft group of companies.\n\n"

        let madeByText = "App design by Beard diful.\nDeveloped by Psylynce."
        let finalText = legalText + madeByText

        return finalText
    }

    var appReviewUrl: URL? {
        guard let urlString = appStoreUrlString else { return nil }
        return URL(string: urlString)
    }

    var version: String? {
        if let info = Bundle.main.infoDictionary, let version = info["CFBundleShortVersionString"] {
            return "v \(version)"
        } else {
            return nil
        }
    }

    init() {
        updateAppStoreUrl()
    }

    fileprivate var appStoreUrlString: String? {
        get {
            return UserDefaults.standard.string(forKey: K.appStoreUrlKey) ?? "https://itunes.apple.com/app/id\(K.appId)"
        }
        set {
            if newValue != appStoreUrlString {
                UserDefaults.standard.set(newValue, forKey: K.appStoreUrlKey)
                UserDefaults.standard.synchronize()
            }
        }
    }

    fileprivate func updateAppStoreUrl() {
        guard let url = URL(string: "https://raw.githubusercontent.com/Psylynce/Halo5Stats/develop/config.json") else { return }

        let task = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                self?.parseConfig(json)
            } catch {
                return
            }
        }) 

        task.resume()
    }

    fileprivate func parseConfig(_ json: [String: AnyObject]?) {
        guard let json = json else { return }

        if let urlValue = json[K.appStoreUrlKey] as? String {
            appStoreUrlString = urlValue
        }
    }
}
