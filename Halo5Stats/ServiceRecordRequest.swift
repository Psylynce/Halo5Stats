//
//  ServiceRecordRequest.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

struct ServiceRecordRequest: RequestProtocol {
    
    let gamertags: [String]
    let gameMode: APIConstants.GameMode
    let gamertagsString: String
    
    // MARK: Initialization
    
    init(gamertags: [String], gameMode: APIConstants.GameMode) {
        self.gamertags = gamertags
        self.gameMode = gameMode
        self.gamertagsString = gamertags.joined(separator: ",")
    }
    
    // MARK: RequestProtocol
    
    var name: String {
        return "\(gameMode.rawValue)_\(gamertagsString)_ServiceRecord"
    }
    
    var url: URL {
        let substitutions = [APIConstants.GameModeKey : gameMode.rawValue]
        let params = [APIConstants.PlayersKey : gamertagsString]
        let endpoint = Endpoint(service: APIConstants.StatsService, path: APIConstants.StatsServiceRecords, parameters: params)
        let url = endpoint.url(withSubstitutions: substitutions)
        
        return url as URL
    }
    
    var cacheKey: String {
        return "\(gamertagsString)_\(gameMode.rawValue)_serviceRecord"
    }

    var jsonKey: String {
        return "serviceRecord"
    }
    
    var parseBlock: RequestParseBlock = ServiceRecordRequest.parseServiceRecord()
    
    // MARK: Private
    
    fileprivate static func parseServiceRecord() -> ((_ name: String, _ context: NSManagedObjectContext, _ data: [String : AnyObject]) -> Void) {
        func parse(_ name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void {
            let nameComponents = name.components(separatedBy: "_")
            guard let gameMode = APIConstants.GameMode(rawValue: nameComponents[0]) else {
                print("Something went wrong!")
                return
            }

            switch gameMode {
            case .Arena:
                print("Parse Arena")
                ServiceRecord.parse(.Arena, data: data, context: context)
            case .Warzone:
                print("Parse Warzone")
                ServiceRecord.parse(.Warzone, data: data, context: context)
            case .Custom:
                print("Parse Custom")
                ServiceRecord.parse(.Custom, data: data, context: context)
            }
        }
        
        return parse
    }
}
