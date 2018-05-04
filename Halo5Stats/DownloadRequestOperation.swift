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

        let urlRequest = Endpoint.haloRequest(with: request.url)

        let task = URLSession.shared.downloadTask(with: urlRequest) { [weak self] (url, response, error) in
            guard let strongSelf = self else { return }
            strongSelf.downloadFinished(url, response: response, error: error)
        }

        let taskOperation = URLSessionTaskOperation(task: task)
        
        let reachabilityCondition = ReachabilityCondition(host: request.url)
        taskOperation.addCondition(reachabilityCondition)
        
        let networkObserver = NetworkObserver()
        taskOperation.addObserver(networkObserver)
        
        addOperation(taskOperation)
    }
    
    func downloadFinished(_ url: URL?, response: URLResponse?, error: Error?) {
        if let localURL = url {
            let manager = Foundation.FileManager.default
            do {
                try manager.removeItem(at: cacheFile)
            }
            catch { }
            
            do {
                try manager.moveItem(at: localURL, to: cacheFile)
            }
            catch let error {
                aggregateError(error)
            }
            
        } else if let error = error {
            aggregateError(error)
        } else {
            // Do nothing, and the operation will automatically finish.
        }
    }
}
