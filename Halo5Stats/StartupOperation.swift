//
//  StartupOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class StartupOperation: GroupOperation {

    let initializeObjectStoreOperation: InitializeObjectStoreOperation

    init(completion: @escaping () -> Void) {
        initializeObjectStoreOperation = InitializeObjectStoreOperation()

        let finishOperation = Foundation.BlockOperation(block: completion)
        finishOperation.addDependency(initializeObjectStoreOperation)

        let operations: [Foundation.Operation] = [initializeObjectStoreOperation, finishOperation]

        super.init(operations: operations)

        name = "Startup Operation"
    }
}
