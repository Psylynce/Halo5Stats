//
//  NSPredicate+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import CoreData

extension NSPredicate {

    class func predicate(withIdentifier identifier: String) -> NSPredicate {
        let predicate = NSPredicate(format: "identifier == %@", identifier)

        return predicate
    }

    class func predicate(withNumberIdentifier identifier: NSNumber) -> NSPredicate {
        let predicate = NSPredicate(format: "identifier == %@", identifier)

        return predicate
    }

    class func predicate(withGamertag gt: String) -> NSPredicate {
        let predicate = NSPredicate(format: "gamertag == %@", gt)

        return predicate
    }
}
