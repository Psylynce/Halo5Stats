//
//  ParseRequestOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ParseRequestOperation: Operation {
    
    let request: RequestProtocol
    let cacheFile: URL
    
    // MARK: Initialization
    
    init(request: RequestProtocol, cacheFile: URL) {
        self.request = request
        self.cacheFile = cacheFile
        super.init()
        name = "Parsing \(request.name)"
    }
    
    override func execute() {
        guard let stream = InputStream(url: cacheFile) else {
            finish()
            return
        }
        
        stream.open()
        
        defer {
            stream.close()
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: stream, options: [])
            let jsonDict = FileManager.sharedManager.ensureJSONDict(json, key: request.jsonKey)
            parse(jsonDict)
        }
        catch let jsonError as NSError {
            finishWithError(jsonError)
        }
    }
    
    // MARK: Private

    fileprivate func parse(_ data: [String : AnyObject]) {
        let controller = UIApplication.appController().persistenceController
        let context = controller?.createChildContext()
        
        context?.perform {
            self.request.parseBlock(self.request.name, context!, data)
            
            controller?.saveChildContext(context)
            controller?.save()
            
            self.finish()
        }
    }
}
