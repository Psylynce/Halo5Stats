//
//  GamertagManager.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import UIKit

class GamertagManager {
    
    // MARK: Singleton
    
    static let sharedManager = GamertagManager()

    // MARK: Types
    
    struct K {
        static let minGamertagLength = 1
        static let maxGamertagLength = 15
        static let userGamertagIdentifier = "userGamertagIdentifier"
        static let notificationName = "Halo5Stats.UpdatedDefaultGamertag"
    }

    // MARK: Class Methods

    func defaultGamertagChanged() {
        NSNotificationCenter.defaultCenter().postNotificationName(K.notificationName, object: nil)
    }

    func saveUserGamertag(gamertag: String) {
        NSUserDefaults.standardUserDefaults().setObject(gamertag, forKey: K.userGamertagIdentifier)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func gamertagForUser() -> String? {
        guard let gamertag = NSUserDefaults.standardUserDefaults().stringForKey(K.userGamertagIdentifier) else {
            print("There was no gamertag found in user defaults")
            
            return nil
        }
        
        return gamertag
    }

    func gamertagExists() -> Bool {
        guard let gamertag = gamertagForUser() else { return false }

        return gamertag.characters.count > 0
    }
    
    func errorMessage() -> (title: String, message: String) {
        let title = "Invalid Gamertag"
        let message = "You can use up to 15 characters: Aa-Zz, 0-9, and single spaces. It can’t start with a number and can’t start or end with a space."
        
        return (title, message)
    }

    func alert(context: UIViewController?) -> AlertOperation {
        let error = errorMessage()
        let alert = AlertOperation(presentationContext: context)
        alert.title = error.title
        alert.message = error.message

        return alert
    }

    func containsGamertagCharacters(gamertag: String) -> Bool {
        let invertedGamertagCharacterSet = NSCharacterSet.gamertagCharacterSet().invertedSet
        let isValidCharacterSet = gamertag.rangeOfCharacterFromSet(invertedGamertagCharacterSet) == nil
        
        return isValidCharacterSet
    }
    
    func isGamertagValid(gamertag: String) -> Bool {
        let isMinMaxValid = gamertag.isMinAndMaxLength(K.minGamertagLength, max: K.maxGamertagLength)
        
        let isValidCharacterSet = containsGamertagCharacters(gamertag)
        
        let beginningAndEndAreValid = areBeginningAndEndValid(gamertag)
        
        let spacesAreValid = gamertag.rangeOfString("  +", options: NSStringCompareOptions.RegularExpressionSearch) == nil
        
        return isMinMaxValid && isValidCharacterSet && beginningAndEndAreValid && spacesAreValid
    }
    
    // MARK: Private
    
    private func areBeginningAndEndValid(gamertag: String) -> Bool {
        guard let first = gamertag.first(), last = gamertag.last() else { return false }
        
        let numericCharacterSet = NSCharacterSet.numericCharacterSet()
        let beginsWithNonNumber = first.rangeOfCharacterFromSet(numericCharacterSet) == nil
        
        let doesNotBeginWithSpace = first != " "
        let doesNotEndWithSpace = last != " "
        
        return beginsWithNonNumber && doesNotBeginWithSpace && doesNotEndWithSpace
    }
}

