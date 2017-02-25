//
//  DataLoader.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol DataLoader {
    var loadingIndicator: LoadingIndicator! { get }
    func showIndicator(animate: Bool)
    func hideIndicator()
}
