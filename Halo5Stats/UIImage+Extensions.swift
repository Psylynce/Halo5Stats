//
//  UIImage+Extensions.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

extension UIImage {

    func cropped(_ rect: CGRect) -> UIImage? {
        var rect = rect
        if scale > 1.0 {
            rect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        }

        if let imageRef = self.cgImage?.cropping(to: rect) {
            let image = UIImage(cgImage: imageRef, scale: scale, orientation: self.imageOrientation)
            return image
        }

        return nil
    }
}
