//
//  StringExtension.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import Foundation

extension String: Collection {
    
    func first() -> String? {
        if isEmpty { return nil }
        
        return String(self[self.startIndex])
    }
    
    func last() -> String? {
        if isEmpty { return nil }
        
        return String(self[self.characters.index(self.endIndex, offsetBy: -1)])
    }
    
    func isMinLength(_ length: Int) -> Bool {
        return self.characters.count >= length
    }
    
    func isMaxLength(_ length: Int) -> Bool {
        return self.characters.count <= length
    }
    
    func isMinAndMaxLength(_ min: Int, max: Int) -> Bool {
        let isMin = self.isMinLength(min)
        let isMax = self.isMaxLength(max)
        
        return isMin && isMax
    }

    var normalizedFromCapitalizedString: String {
        do {
            let regex = try NSRegularExpression(pattern: "(?=\\S)[A-Z]", options: [])
            let range = NSMakeRange(1, characters.count - 1)
            var string = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: " $0")

            for i in string.characters.indices {
                if i == string.startIndex || string[string.index(i, offsetBy: -1)] == " " {
                    string.replaceSubrange(i ... i, with: String(string[i]).uppercased())
                }
            }

            return string
        } catch let error as NSError {
            print("Invalid Regex \(error.localizedDescription)")
            return self
        }
    }
}

extension NSRange {
    func rangeForString(_ string: String) -> Range<String.Index> {
        let startIndex = string.characters.index(string.startIndex, offsetBy: location)
        let endIndex = string.index(startIndex, offsetBy: length)

        let range = startIndex ..< endIndex
        return range
    }
}

