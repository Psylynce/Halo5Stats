//
//  UIApplicationExtension.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func appController() -> AppControllerProtocol {
        let appController = UIApplication.shared.delegate as! AppControllerProtocol
        return appController
    }
    
}
