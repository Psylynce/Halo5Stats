//
//  NSCharacterSetExtension.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import Foundation

extension NSCharacterSet {
    
    /**
     Pure digit character set
     */
    static func numericCharacterSet() -> NSCharacterSet {
        return NSCharacterSet(charactersInString: "0123456789")
    }

    /**
        A character set that represents the characters allowed in a gamertag
    */
    static func gamertagCharacterSet() -> NSCharacterSet {
        return NSCharacterSet(charactersInString: "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789 ")
    }
}

