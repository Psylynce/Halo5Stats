//
//  FileManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class FileManager {

    static let sharedManager = FileManager()

    func cacheFile(withKey key: String) -> NSURL {
        let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = cachesFolder.URLByAppendingPathComponent("\(key).json")

        return cacheFile
    }

    func data(forCacheKey cacheKey: String, key: String) -> [String : AnyObject]? {
        let cacheFile = self.cacheFile(withKey: cacheKey)

        guard let stream = NSInputStream(URL: cacheFile) else {
            return nil
        }

        stream.open()

        defer {
            stream.close()
        }

        do {
            let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: [])
            let jsonDict = ensureJSONDict(json, key: key)
            return jsonDict
        }
        catch {
            return nil
        }
    }

    func ensureJSONDict(json: AnyObject, key: String) -> [String : AnyObject] {
        guard let jsonDict = json as? [String : AnyObject] else {
            return [key : json]
        }

        return jsonDict
    }
}
