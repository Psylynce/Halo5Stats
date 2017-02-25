//
//  SaveGamertagOperation.swift
//  Halo5Stats
//
//  Copyright © 2015 Justin Powell. All rights reserved.
//

import Foundation

class SaveGamertagOperation: Operation {
    
    // MARK: Properties
    
    let gamertag: String
    fileprivate let manager = GamertagManager()
    
    // MARK: Initialization
    
    init(gamertag: String) {
        self.gamertag = gamertag
        
        super.init()
    }
    
    // MARK: Execution
    
    override func execute() {
        manager.saveUserGamertag(gamertag)
        SpartanManager.sharedManager.saveSpartan(gamertag)
        if let gamertag = manager.gamertagForUser() {
            print(gamertag)
        }
    }
}

