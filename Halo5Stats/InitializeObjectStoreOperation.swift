//
//  InitializeObjectStoreOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class InitializeObjectStoreOperation: GroupOperation {
    
    let loadOperation: LoadObjectStoreOperation
    // MARK: Initialization
    
    init() {
        loadOperation = LoadObjectStoreOperation()
        
        super.init(operations: [loadOperation])
        
        addCondition(MutuallyExclusive<InitializeObjectStoreOperation>())
        
        name = "Initialize Object Store"
    }
}
