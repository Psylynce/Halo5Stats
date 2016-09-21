//
//  UIImageView+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func image(forUrl url: NSURL) {
        tintedImage(forUrl: url, color: nil)
    }

    func tintedImage(forUrl url: NSURL, color: UIColor?) {
        ImageCache.sharedInstance.image(forUrl: url) { [weak self] (response) in
            switch response {
            case .Error:
                return
            case .Success(var image):
                dispatch_async(dispatch_get_main_queue()) {
                    if let color = color {
                        image = image.imageWithRenderingMode(.AlwaysTemplate)
                        self?.tintColor = color
                    }
                    self?.image = image
                }
            }
        }
    }

    func croppedImage(forUrl url: NSURL, cropRect: CGRect) {
        ImageCache.sharedInstance.croppedImage(forUrl: url, cropRect: cropRect) { [weak self] (response) in
            switch response {
            case .Error:
                return
            case .Success(let image):
                dispatch_async(dispatch_get_main_queue()) {
                    self?.image = image
                }
            }
        }
    }
}
