//
//  NSURLSessionExtension.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension URLSession {

    class func halo5ConfiguredSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        if let key = KeyManager.sharedManager.apiKey {
            configuration.httpAdditionalHeaders = [APIConstants.KeyHeader : key]
        }
        
        let session = URLSession(configuration: configuration)
        
        return session
    }
}
