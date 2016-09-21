//
//  RequestProtocol.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

typealias RequestParseBlock = (name: String, context: NSManagedObjectContext, data: [String : AnyObject]) -> Void

protocol RequestProtocol {
    var name: String { get }
    var url: NSURL { get }
    var cacheKey: String { get }
    var jsonKey: String { get }
    var cacheFile: NSURL { get }
    var data: [String : AnyObject]? { get }
    
    var parseBlock: RequestParseBlock { get }
}

extension RequestProtocol {

    var cacheFile: NSURL {
        return FileManager.sharedManager.cacheFile(withKey: cacheKey)
    }

    var data: [String : AnyObject]? {
        return FileManager.sharedManager.data(forCacheKey: cacheKey, key: jsonKey)
    }
}
