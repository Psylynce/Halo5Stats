//
//  CarnageReportRequest.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

struct CarnageReportRequest: RequestProtocol {

    let path: String

    init(path: String) {
        self.path = path
    }

    // MARK: - RequestProtocol

    var name: String {
        return "\(matchId)_CarnageReport"
    }

    var url: NSURL {
        let endpoint = Endpoint(service: APIConstants.StatsService, path: path)
        let url = endpoint.url()

        return url
    }

    var cacheKey: String {
        return "\(matchId)-carnageReport"
    }

    var jsonKey: String {
        return "carnageReport"
    }

    var parseBlock: RequestParseBlock = CarnageReportRequest.parseCarnageReport()

    // MARK: Private

    private static func parseCarnageReport() -> ((name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void) {
        func parse(name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void {
            let matchId = name.componentsSeparatedByString("_")[0]
            CarnageReport.parse(data, matchId: matchId, context: context)
        }

        return parse
    }

    private var matchId: String {
        let pathArray = path.componentsSeparatedByString("/")

        if pathArray.count == 3 {
            return pathArray[2]
        } else {
            return path.stringByReplacingOccurrencesOfString("/", withString: "_")
        }
    }
}
