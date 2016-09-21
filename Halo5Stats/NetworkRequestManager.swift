//
//  NetworkRequestManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class NetworkRequestManager {

    static let sharedManager = NetworkRequestManager()

    enum RequestType: String {
        case Metadata = "metadataRequestDate"
        case Matches = "matchesRequestDate"
        case Arena = "arenaServiceRecordRequestDate"
        case Warzone = "warzoneServiceRecordRequestDate"
        case Custom = "customServiceRecordRequestDate"

        func date() -> NSDate? {
            switch self {
            case .Metadata:
                return NSDate().daysFromNow(3)
            case .Matches:
                return NSDate().daysFromNow(1)
            case .Arena, .Warzone, .Custom:
                return NSDate().daysFromNow(1)
            }
        }

        static func requestType(forGameMode gameMode: GameMode) -> RequestType {
            switch gameMode {
            case .Arena:
                return RequestType.Arena
            case .Warzone:
                return RequestType.Warzone
            case .Custom:
                return RequestType.Custom
            }
        }
    }

    func shouldSendRequest(requestType: RequestType, force: Bool = false) -> Bool {
        guard let nextDate = nextDate(forRequestType: requestType) else {
            setNextRequestDate(requestType)
            return true
        }

        if force {
            return true
        }

        let shouldSend = nextDate.timeIntervalSince1970 <= NSDate().timeIntervalSince1970
        if shouldSend {
            setNextRequestDate(requestType)
        }

        return shouldSend
    }

    private func setNextRequestDate(requestType: RequestType) {
        let nextDate = requestType.date()
        NSUserDefaults.standardUserDefaults().setValue(nextDate, forKey: requestType.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    private func nextDate(forRequestType rt: RequestType) -> NSDate? {
        return NSUserDefaults.standardUserDefaults().valueForKey(rt.rawValue) as? NSDate
    }
}
