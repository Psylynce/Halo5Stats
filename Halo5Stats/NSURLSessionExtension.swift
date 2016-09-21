//
//  NSURLSessionExtension.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension NSURLSession {

    class func halo5ConfiguredSession() -> NSURLSession {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        if let key = KeyManager.sharedManager.apiKey {
            configuration.HTTPAdditionalHeaders = [APIConstants.KeyHeader : key]
        }
        
        let session = NSURLSession(configuration: configuration)
        
        return session
    }
}
