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
        case metadata = "metadataRequestDate"
        case matches = "matchesRequestDate"
        case arena = "arenaServiceRecordRequestDate"
        case warzone = "warzoneServiceRecordRequestDate"
        case custom = "customServiceRecordRequestDate"

        func date() -> Date? {
            switch self {
            case .metadata:
                return Date().daysFromNow(3)
            case .matches:
                return Date().daysFromNow(1)
            case .arena, .warzone, .custom:
                return Date().daysFromNow(1)
            }
        }

        static func requestType(forGameMode gameMode: GameMode) -> RequestType {
            switch gameMode {
            case .arena:
                return RequestType.arena
            case .warzone:
                return RequestType.warzone
            case .custom:
                return RequestType.custom
            }
        }
    }

    func shouldSendRequest(_ requestType: RequestType, force: Bool = false) -> Bool {
        guard let nextDate = nextDate(forRequestType: requestType) else {
            setNextRequestDate(requestType)
            return true
        }

        if force {
            return true
        }

        let shouldSend = nextDate.timeIntervalSince1970 <= Date().timeIntervalSince1970
        if shouldSend {
            setNextRequestDate(requestType)
        }

        return shouldSend
    }

    fileprivate func setNextRequestDate(_ requestType: RequestType) {
        let nextDate = requestType.date()
        UserDefaults.standard.setValue(nextDate, forKey: requestType.rawValue)
        UserDefaults.standard.synchronize()
    }

    fileprivate func nextDate(forRequestType rt: RequestType) -> Date? {
        return UserDefaults.standard.value(forKey: rt.rawValue) as? Date
    }
}
