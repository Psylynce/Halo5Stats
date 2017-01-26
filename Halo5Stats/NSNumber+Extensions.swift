//
//  NSNumber+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

extension NSNumber {

    convenience init?(identifier: String?) {
        guard let id = identifier else {
            print("Identifier was not a string")
            return nil
        }
        guard let number = Int(id) else {
            print("Identifier could not be turned into a number")
            return nil
        }
        self.init(value: number as Int)
    }
}
