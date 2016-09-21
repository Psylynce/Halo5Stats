//
//  AppControllerProtocol.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import CoreData

protocol AppControllerProtocol: class {
    var applicationViewController: ApplicationViewController! { get }
    var operationQueue: OperationQueue! { get }
    var persistenceController: PersistenceController! { get set }
    
    func managedObjectContext() -> NSManagedObjectContext
}
