//
//  MetadataRequest.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

struct MetadataRequest: RequestProtocol {
    
    let metadataType: APIConstants.MetadataType
    
    // MARK: Initialization
    
    init(metadataType: APIConstants.MetadataType) {
        self.metadataType = metadataType
    }
    
    // MARK: RequestProtocol
    
    var name: String {
        return "\(metadataType.rawValue) Request"
    }
    
    var url: NSURL {
        let substitutions = [APIConstants.MetadataKey : metadataType.rawValue]
        let endpoint = Endpoint(service: APIConstants.MetadataService, path: APIConstants.Metadata)
        let url = endpoint.url(withSubstitutions: substitutions)
        
        return url
    }
    
    var cacheKey: String {
        return "\(metadataType.rawValue)"
    }

    var jsonKey: String {
        return "\(metadataType.rawValue)"
    }
    
    var parseBlock: RequestParseBlock = MetadataRequest.parseMetadata()
    
    // MARK: Private
    
    private static func parseMetadata() -> ((name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void) {
        func parse(name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void {            
            let metadataTypeString = name.stringByReplacingOccurrencesOfString("Request", withString: "")
                .stringByReplacingOccurrencesOfString(" ", withString: "")
            guard let metadataType = APIConstants.MetadataType(rawValue: metadataTypeString) else {
                print("Something went wrong!")
                return
            }
            
            switch metadataType {
            case .CSRDesignations:
                print("Will Parse CSR Designations")
                CSRDesignation.parse(data, context: context)
            case .Enemies:
                print("Will Parse Enemies")
                Enemy.parse(data, context: context)
            case .GameBaseVariants:
                print("Will Parse Game Base Variants")
                GameBaseVariant.parse(data, context: context)
            case .Maps:
                print("Will Parse Maps")
                Map.parse(data, context: context)
            case .Medals:
                print("Will Parse Medals")
                Medal.parse(data, context: context)
            case .Playlists:
                print("Will Parse Playlists")
                Playlist.parse(data, context: context)
            case .Seasons:
                print("Will Parse Seasons")
                Season.parse(data, context: context)
            case .TeamColors:
                print("Will Parse Team Colors")
                TeamColor.parse(data, context: context)
            case .Vehicles:
                print("Will Parse Vehicles")
                Vehicle.parse(data, context: context)
            case .Weapons:
                print("Will Parse Weapons")
                Weapon.parse(data, context: context)
            }
        }
        
        return parse
    }
}
