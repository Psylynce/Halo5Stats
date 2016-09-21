//
//  Endpoint.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class Endpoint {
    
    // MARK: Endpoint
    
    // MARK: Initialization
    
    // The service will be either stats, metadata, or profile
    init(service: String, path: String, parameters: [String : String]? = nil) {
        self.basePath = APIConstants.basePath(service)
        self.path = path
        self.parameters = parameters
    }
    
    // MARK: Private

    private let scheme = APIConstants.Scheme
    private let host = APIConstants.Domain
    private let basePath: String
    private let path: String
    private let parameters: [String : String]?
    
    private func url(withSubstitutions substitutions: [String : String], parameters: [String : String]?) -> NSURL {
        var endpointPath = path
        
        for key in substitutions.keys {
            let identifier = "[\(key.uppercaseString)]"
            
            if let value = substitutions[key] {
                endpointPath = endpointPath.stringByReplacingOccurrencesOfString(identifier, withString: value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!)
            }
        }
        
        var urlString = "\(scheme)://\(host)\(basePath)\(endpointPath)"

        if var params = parameters {
            var paramsArray: [String] = []
            for key in params.keys {
                if let encodedValue = params[key]?.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) {
                    paramsArray.append("\(key)=\(encodedValue)")
                }
            }

            let paramsString = paramsArray.joinWithSeparator("&")
            urlString.appendContentsOf("?\(paramsString)")
        }

        let url = NSURL(string: urlString)
        
        return url!
    }
    
    // MARK: Internal
    
    func url() -> NSURL {
        let urlString = "\(scheme)://\(host)\(basePath)"
        let url = NSURL(string: urlString)?.URLByAppendingPathComponent(path)
        
        return url!
    }
    
    func url(withSubstitutions substitutions: [String:String]) -> NSURL {
        return url(withSubstitutions: substitutions, parameters: parameters)
    }
}
