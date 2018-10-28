//
//  UIViewLoadingProtocol.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewLoading {}
extension UIView : UIViewLoading {}

extension UIViewLoading where Self : UIView {

    static func loadFromNib() -> Self {
        let nib = UINib(nibName: String(describing: Self.self), bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }

}
