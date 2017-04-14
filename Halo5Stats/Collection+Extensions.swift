//
//  Collection+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import Foundation

extension Collection where Index: Comparable {

    subscript (safe index: Index) -> _Element? {
        if index >= startIndex && index < endIndex {
            return self[index]
        } else {
            return nil
        }
    }
}
