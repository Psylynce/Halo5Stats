//
//  MatchesRequest.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

struct MatchesRequest: RequestProtocol {

    let gamertag: String
    let parameters: [String : String]?

    init(gamertag: String, parameters: [String : String]? = nil) {
        self.gamertag = gamertag
        self.parameters = parameters
    }

    // MARK: - RequestProtocol

    var name: String {
        return "\(gamertag)_MatchesRequest"
    }

    var url: NSURL {
        let substitutions = [APIConstants.GamertagKey : gamertag]
        let endpoint = Endpoint(service: APIConstants.StatsService, path: APIConstants.StatsPlayerMatches, parameters: parameters)
        let url = endpoint.url(withSubstitutions: substitutions)

        return url
    }

    var cacheKey: String {
        return "\(gamertag)_matches"
    }

    var jsonKey: String {
        return "matches"
    }

    var parseBlock: RequestParseBlock = MatchesRequest.parseMatches()

    // MARK: Private

    private static func parseMatches() -> ((name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void) {
        func parse(name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void {
            let gamertag = name.componentsSeparatedByString("_")[0]
            Match.parse(forGamertag: gamertag, data: data, context: context)
        }

        return parse
    }
}
