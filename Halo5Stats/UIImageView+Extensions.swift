//
//  UIImageView+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {

    func image(forUrl url: URL) {
        tintedImage(forUrl: url, color: nil)
    }

    func tintedImage(forUrl url: URL, color: UIColor?) {
        ImageCache.sharedInstance.image(forUrl: url) { [weak self] (response) in
            switch response {
            case .error:
                return
            case .success(var image):
                DispatchQueue.main.async {
                    if let color = color {
                        image = image.withRenderingMode(.alwaysTemplate)
                        self?.tintColor = color
                    }
                    self?.image = image
                }
            }
        }
    }

    func croppedImage(forUrl url: URL, cropRect: CGRect) {
        ImageCache.sharedInstance.croppedImage(forUrl: url, cropRect: cropRect) { [weak self] (response) in
            switch response {
            case .error:
                return
            case .success(let image):
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
