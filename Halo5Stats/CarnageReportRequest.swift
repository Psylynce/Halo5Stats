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

    var url: URL {
        let endpoint = Endpoint(service: .stats, path: path)
        let url = endpoint.url()

        return url as URL
    }

    var cacheKey: String {
        return "\(matchId)-carnageReport"
    }

    var jsonKey: String {
        return "carnageReport"
    }

    var parseBlock: RequestParseBlock = CarnageReportRequest.parseCarnageReport()

    // MARK: Private

    fileprivate static func parseCarnageReport() -> ((_ name: String, _ context: NSManagedObjectContext, _ data: [String : AnyObject]) -> Void) {
        func parse(_ name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void {
            let matchId = name.components(separatedBy: "_")[0]
            CarnageReport.parse(data, matchId: matchId, context: context)
        }

        return parse
    }

    fileprivate var matchId: String {
        let pathArray = path.components(separatedBy: "/")

        if pathArray.count == 3 {
            return pathArray[2]
        } else {
            return path.replacingOccurrences(of: "/", with: "_")
        }
    }
}
