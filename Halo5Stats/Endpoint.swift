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

    fileprivate let scheme = APIConstants.Scheme
    fileprivate let host = APIConstants.Domain
    fileprivate let basePath: String
    fileprivate let path: String
    fileprivate let parameters: [String : String]?
    
    fileprivate func url(withSubstitutions substitutions: [String : String], parameters: [String : String]?) -> URL {
        var endpointPath = path
        
        for key in substitutions.keys {
            let identifier = "[\(key.uppercased())]"
            
            if let value = substitutions[key] {
                endpointPath = endpointPath.replacingOccurrences(of: identifier, with: value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)
            }
        }
        
        var urlString = "\(scheme)://\(host)\(basePath)\(endpointPath)"

        if var params = parameters {
            var paramsArray: [String] = []
            for key in params.keys {
                if let encodedValue = params[key]?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed) {
                    paramsArray.append("\(key)=\(encodedValue)")
                }
            }

            let paramsString = paramsArray.joined(separator: "&")
            urlString.append("?\(paramsString)")
        }

        let url = URL(string: urlString)
        
        return url!
    }
    
    // MARK: Internal
    
    func url() -> URL {
        let urlString = "\(scheme)://\(host)\(basePath)"
        let url = URL(string: urlString)?.appendingPathComponent(path)
        
        return url!
    }
    
    func url(withSubstitutions substitutions: [String:String]) -> URL {
        return url(withSubstitutions: substitutions, parameters: parameters)
    }
}
