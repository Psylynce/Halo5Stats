//
//  APIRequestOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class APIRequestOperation: GroupOperation {
    
    let downloadOperation: DownloadRequestOperation
    let parseOperation: ParseRequestOperation
    
    // MARK: Initialization
    
    init(request: RequestProtocol, shouldParse: Bool = true, completion: @escaping () -> Void) {
        let cacheFile = request.cacheFile
        
        downloadOperation = DownloadRequestOperation(request: request, cacheFile: cacheFile)
        parseOperation = ParseRequestOperation(request: request, cacheFile: cacheFile)

        let finishOperation = Foundation.BlockOperation(block: completion)
        finishOperation.addDependency(downloadOperation)

        var operations: [Foundation.Operation] = [downloadOperation]

        if shouldParse {
            operations.append(parseOperation)
            parseOperation.addDependency(downloadOperation)
            finishOperation.removeDependency(downloadOperation)
            finishOperation.addDependency(parseOperation)
        }

        operations.append(finishOperation)
        
        super.init(operations: operations)
        
        name = "Get \(request.name)"
    }

}
