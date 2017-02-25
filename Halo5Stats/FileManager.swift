//
//  FileManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class FileManager {

    static let sharedManager = FileManager()

    func cacheFile(withKey key: String) -> URL {
        let cachesFolder = try! Foundation.FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let cacheFile = cachesFolder.appendingPathComponent("\(key).json")

        return cacheFile
    }

    func data(forCacheKey cacheKey: String, key: String) -> [String : AnyObject]? {
        let cacheFile = self.cacheFile(withKey: cacheKey)

        guard let stream = InputStream(url: cacheFile) else {
            return nil
        }

        stream.open()

        defer {
            stream.close()
        }

        do {
            let json = try JSONSerialization.jsonObject(with: stream, options: [])
            let jsonDict = ensureJSONDict(json as AnyObject, key: key)
            return jsonDict
        }
        catch {
            return nil
        }
    }

    func ensureJSONDict(_ json: Any, key: String) -> [String : AnyObject] {
        guard let jsonDict = json as? [String : AnyObject] else {
            return [key : json as AnyObject]
        }

        return jsonDict
    }
}
