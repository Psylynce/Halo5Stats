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
    let cacheFile: NSURL
    
    // MARK: Initialization
    
    init(request: RequestProtocol, cacheFile: NSURL) {
        self.request = request
        self.cacheFile = cacheFile
        super.init()
        name = "Parsing \(request.name)"
    }
    
    override func execute() {
        guard let stream = NSInputStream(URL: cacheFile) else {
            finish()
            return
        }
        
        stream.open()
        
        defer {
            stream.close()
        }
        
        do {
            let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: [])
            let jsonDict = FileManager.sharedManager.ensureJSONDict(json, key: request.jsonKey)
            parse(jsonDict)
        }
        catch let jsonError as NSError {
            finishWithError(jsonError)
        }
    }
    
    // MARK: Private

    private func parse(data: [String : AnyObject]) {
        let controller = UIApplication.appController().persistenceController
        let context = controller.createChildContext()
        
        context.performBlock {
            self.request.parseBlock(name: self.request.name, context: context, data: data)
            
            controller.saveChildContext(context)
            controller.save()
            
            self.finish()
        }
    }
}
