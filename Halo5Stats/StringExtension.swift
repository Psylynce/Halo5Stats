//
//  StringExtension.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import Foundation

extension String: Indexable {
    
    func first() -> String? {
        if isEmpty { return nil }
        
        return String(self[self.startIndex])
    }
    
    func last() -> String? {
        if isEmpty { return nil }
        
        return String(self[self.endIndex.advancedBy(-1)])
    }
    
    func isMinLength(length: Int) -> Bool {
        return self.characters.count >= length
    }
    
    func isMaxLength(length: Int) -> Bool {
        return self.characters.count <= length
    }
    
    func isMinAndMaxLength(min: Int, max: Int) -> Bool {
        let isMin = self.isMinLength(min)
        let isMax = self.isMaxLength(max)
        
        return isMin && isMax
    }

    var normalizedFromCapitalizedString: String {
        do {
            let regex = try NSRegularExpression(pattern: "(?=\\S)[A-Z]", options: [])
            let range = NSMakeRange(1, characters.count - 1)
            var string = regex.stringByReplacingMatchesInString(self, options: [], range: range, withTemplate: " $0")

            for i in string.startIndex ..< string.endIndex {
                if i == string.startIndex || string[i.advancedBy(-1)] == " " {
                    string.replaceRange(i ... i, with: String(string[i]).uppercaseString)
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
    func rangeForString(string: String) -> Range<String.Index> {
        let startIndex = string.startIndex.advancedBy(location)
        let endIndex = startIndex.advancedBy(length)

        let range = startIndex ..< endIndex
        return range
    }
}

