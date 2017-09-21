//
//  SettingsViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class SettingsViewModel {

    enum Row {
        case changeDefault

        var name: String {
            switch self {
            case .changeDefault:
                return "Change Default Gamertag"
            }
        }
    }

    var rows: [Row] = [.changeDefault]

    var legalText: String {
        let myName = "Justin Powell"
        let today = Date()
        let currentYear = (Calendar.current as NSCalendar).component(.year, from: today)

        let legalText = "This application is offered by \(myName), which is solely responsible for its content. It is not sponsored or endorsed by Microsoft. This application uses the Halo® Game Data API. Halo © \(currentYear) Microsoft Corporation. All rights reserved. Microsoft, Halo, and the Halo Logo are trademarks of the Microsoft group of companies.\n\n"

        let madeByText = "App design by Beard diful.\nDeveloped by Psylynce."
        let finalText = legalText + madeByText

        return finalText
    }

    var version: String? {
        if let info = Bundle.main.infoDictionary, let version = info["CFBundleShortVersionString"] {
            return "v \(version)"
        } else {
            return nil
        }
    }
}
