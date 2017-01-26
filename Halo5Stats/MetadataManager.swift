//
//  MetadataManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct MetadataManager {

    struct K {
        static let initialMetadataLoaded = "initialMetadataLoaded"
        static let updatedMetadataDateKey = "updatedMetadataDateKey"
    }

    static var updatedMetadataDate: Date? {
        set {
            if let date = newValue {
                UserDefaults.standard.set(date, forKey: K.updatedMetadataDateKey)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: K.updatedMetadataDateKey)
            }
        }
        get {
            let date = UserDefaults.standard.object(forKey: K.updatedMetadataDateKey) as? Date
            return date
        }
    }

    static var initialMetadataLoaded: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: K.initialMetadataLoaded)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: K.initialMetadataLoaded)
        }
    }

    static func shouldUpdateMetadata() -> Bool {
        let today = Date()
        guard let lastUpdatedDate = updatedMetadataDate else {
            updatedMetadataDate = today
            return true
        }

        let oneDayFromLastUpdated = lastUpdatedDate.daysFromDate(1)

        guard today.timeIntervalSince1970 >= oneDayFromLastUpdated.timeIntervalSince1970 else { return false }
        updatedMetadataDate = today

        return true
    }

    static func fetchMetadata(_ completion: (Void) -> Void) {
        let metadataOperation = DownloadAndParseMetadataOperation(completion: completion)
        UIApplication.appController().operationQueue.addOperation(metadataOperation)
    }
}
