//
//  RequestProtocol.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

typealias RequestParseBlock = (_ name: String, _ context: NSManagedObjectContext, _ data: [String : AnyObject]) -> Void

protocol RequestProtocol {
    var name: String { get }
    var url: URL { get }
    var cacheKey: String { get }
    var jsonKey: String { get }
    var cacheFile: URL { get }
    var data: [String : AnyObject]? { get }
    
    var parseBlock: RequestParseBlock { get }
}

extension RequestProtocol {

    var cacheFile: URL {
        return FileManager.sharedManager.cacheFile(withKey: cacheKey) as URL
    }

    var data: [String : AnyObject]? {
        return FileManager.sharedManager.data(forCacheKey: cacheKey, key: jsonKey)
    }
}
