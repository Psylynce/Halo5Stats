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
        NotificationCenter.default.post(name: Notification.Name(rawValue: K.notificationName), object: nil)
    }

    func saveUserGamertag(_ gamertag: String) {
        UserDefaults.standard.set(gamertag, forKey: K.userGamertagIdentifier)
        UserDefaults.standard.synchronize()
    }
    
    func gamertagForUser() -> String? {
        guard let gamertag = UserDefaults.standard.string(forKey: K.userGamertagIdentifier) else {
            print("There was no gamertag found in user defaults")
            
            return nil
        }
        
        return gamertag
    }

    func gamertagExists() -> Bool {
        guard let gamertag = gamertagForUser() else { return false }

        return gamertag.count > 0
    }
    
    func errorMessage() -> (title: String, message: String) {
        let title = "Invalid Gamertag"
        let message = "You can use up to 15 characters: Aa-Zz, 0-9, and single spaces. It can’t start with a number and can’t start or end with a space."
        
        return (title, message)
    }

    func alert(_ context: UIViewController?) -> AlertOperation {
        let error = errorMessage()
        let alert = AlertOperation(presentationContext: context)
        alert.title = error.title
        alert.message = error.message

        return alert
    }

    func containsGamertagCharacters(_ gamertag: String) -> Bool {
        let invertedGamertagCharacterSet = CharacterSet.gamertagCharacterSet().inverted
        let isValidCharacterSet = gamertag.rangeOfCharacter(from: invertedGamertagCharacterSet) == nil
        
        return isValidCharacterSet
    }
    
    func isGamertagValid(_ gamertag: String) -> Bool {
        let isMinMaxValid = gamertag.isMinAndMaxLength(K.minGamertagLength, max: K.maxGamertagLength)
        
        let isValidCharacterSet = containsGamertagCharacters(gamertag)
        
        let beginningAndEndAreValid = areBeginningAndEndValid(gamertag)
        
        let spacesAreValid = gamertag.range(of: "  +", options: NSString.CompareOptions.regularExpression) == nil
        
        return isMinMaxValid && isValidCharacterSet && beginningAndEndAreValid && spacesAreValid
    }
    
    // MARK: Private
    
    fileprivate func areBeginningAndEndValid(_ gamertag: String) -> Bool {
        guard let first = gamertag.first(), let last = gamertag.last() else { return false }
        
        let numericCharacterSet = CharacterSet.numericCharacterSet()
        let beginsWithNonNumber = first.rangeOfCharacter(from: numericCharacterSet) == nil
        
        let doesNotBeginWithSpace = first != " "
        let doesNotEndWithSpace = last != " "
        
        return beginsWithNonNumber && doesNotBeginWithSpace && doesNotEndWithSpace
    }
}

