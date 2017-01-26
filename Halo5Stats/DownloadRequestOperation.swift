//
//  DownloadRequestOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class DownloadRequestOperation: GroupOperation {
    
    let cacheFile: URL
    // MARK: Initialization
    
    init(request: RequestProtocol, cacheFile: URL) {
        self.cacheFile = cacheFile
        super.init(operations: [])
        name = "Downloading \(request.name)"
        
        let url = request.url
        let task = URLSession.halo5ConfiguredSession().downloadTask(with: url, completionHandler: { url, response, error in
            self.downloadFinished(url, response: response as HTTPURLResponse, error: error)
        }) 
        
        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: url)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        
        addOperation(taskOperation)
    }
    
    func downloadFinished(_ url: URL?, response: HTTPURLResponse?, error: NSError?) {
        if let localURL = url {
            do {
                try Foundation.FileManager.default.removeItem(at: cacheFile)
            }
            catch { }
            
            do {
                try Foundation.FileManager.default.moveItem(at: localURL, to: cacheFile)
            }
            catch let error as NSError {
                aggregateError(error)
            }
            
        } else if let error = error {
            aggregateError(error)
        } else {
            // Do nothing, and the operation will automatically finish.
        }
    }

}
