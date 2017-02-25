//
//  NSCharacterSetExtension.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import Foundation

extension CharacterSet {
    
    /**
     Pure digit character set
     */
    static func numericCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "0123456789")
    }

    /**
        A character set that represents the characters allowed in a gamertag
    */
    static func gamertagCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789 ")
    }
}

