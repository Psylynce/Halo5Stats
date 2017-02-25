//
//  CSRDesignation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit
import CoreData


class CSRDesignation: NSManagedObject {

    static func csrDesignation(_ identifier: Int) -> CSRDesignation? {
        let predicate = NSPredicate.predicate(withNumberIdentifier: NSNumber(integerLiteral: identifier))
        let designation = CSRDesignation.findOrFetch(inContext: UIApplication.appController().managedObjectContext(), matchingPredicate: predicate)

        return designation
    }

    func tier(_ identifier: Int) -> CSRTier? {
        guard let name = name else { return nil }
        guard let tiers = self.tiers?.allObjects as? [CSRTier] else { return nil }

        let tierId = "\(name)-\(identifier)"

        for tier in tiers {
            if let tierIdentifier = tier.identifier, tierIdentifier == tierId {
                return tier
            }
        }

        return nil
    }

}

extension CSRDesignation: ManagedObjectTypeProtocol {

    static var entityName: String {
        return "CSRDesignation"
    }

    static func parse(_ data: [String : AnyObject], context: NSManagedObjectContext) {
        guard let csrDesignations = data[JSONKeys.CSR.csrDesignation] as? [AnyObject] else { return }

        for csr in csrDesignations {
            let identifier = csr[JSONKeys.identifier] as? String
            guard let numberIdentifier = NSNumber(identifier: identifier) else {
                continue
            }

            let predicate = NSPredicate.predicate(withNumberIdentifier: numberIdentifier)
            
            CSRDesignation.findOrCreate(inContext: context, matchingPredicate: predicate) {
                $0.name = csr[JSONKeys.name] as? String
                $0.bannerImageUrl = csr[JSONKeys.CSR.bannerImageUrl] as? String
                $0.identifier = numberIdentifier

                if let tierArray = csr[JSONKeys.CSR.tiers] as? [AnyObject] {
                    var tiers: [CSRTier] = []

                    for tier in tierArray {
                        guard let identifier = tier[JSONKeys.identifier] as? String, let designation = $0.name else {
                            print("No CSR Tier")
                            continue
                        }

                        let tierIdentifier = "\(designation)-\(identifier)"
                        let tierPredicate = NSPredicate.predicate(withIdentifier: tierIdentifier)

                        CSRTier.findOrCreate(inContext: context, matchingPredicate: tierPredicate) {
                            $0.identifier = tierIdentifier
                            $0.iconImageUrl = tier[JSONKeys.CSR.iconImageUrl] as? String
                            tiers += [$0]
                        }
                    }

                    $0.tiers = NSSet(array: tiers)
                }
            }
        }
    }
}
