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

    static var updatedMetadataDate: NSDate? {
        set {
            if let date = newValue {
                NSUserDefaults.standardUserDefaults().setObject(date, forKey: K.updatedMetadataDateKey)
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                NSUserDefaults.standardUserDefaults().removeObjectForKey(K.updatedMetadataDateKey)
            }
        }
        get {
            let date = NSUserDefaults.standardUserDefaults().objectForKey(K.updatedMetadataDateKey) as? NSDate
            return date
        }
    }

    static var initialMetadataLoaded: Bool {
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: K.initialMetadataLoaded)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(K.initialMetadataLoaded)
        }
    }

    static func shouldUpdateMetadata() -> Bool {
        let today = NSDate()
        guard let lastUpdatedDate = updatedMetadataDate else {
            updatedMetadataDate = today
            return true
        }

        let oneDayFromLastUpdated = lastUpdatedDate.daysFromDate(1)

        guard today.timeIntervalSince1970 >= oneDayFromLastUpdated.timeIntervalSince1970 else { return false }
        updatedMetadataDate = today

        return true
    }

    static func fetchMetadata(completion: Void -> Void) {
        let metadataOperation = DownloadAndParseMetadataOperation(completion: completion)
        UIApplication.appController().operationQueue.addOperation(metadataOperation)
    }
}
