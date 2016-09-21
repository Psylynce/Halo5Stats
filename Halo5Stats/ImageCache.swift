//
//  ImageCache.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

enum ImageResponse {
    case Success(image: UIImage)
    case Error
}

class ImageCache {

    static let sharedInstance = ImageCache()
    let cache = NSCache()

    private func insert(key: String, image: UIImage) {
        cache.setObject(image, forKey: key)
    }

    private func cachedImage(forKey key: String) -> UIImage? {
        if let image = cache.objectForKey(key) as? UIImage {
            return image
        }

        return nil
    }

    private func image(forUrl url: NSURL, key: String, cropRect: CGRect? = nil, completion: (imageResponse: ImageResponse) -> ()) {
        if let image = cachedImage(forKey: key) {
            completion(imageResponse: .Success(image: image))
            return
        }

        let task = NSURLSession.halo5ConfiguredSession().dataTaskWithURL(url) { [weak self] (data, response, error) in
            guard let data = data where error == nil else { return }

            if let response = response as? NSHTTPURLResponse where response.statusCode == 404 {
                completion(imageResponse: .Error)
            }

            if let image = UIImage(data: data) {
                if let rect = cropRect {
                    if let croppedImage = image.cropped(rect) {
                        self?.insert(key, image: croppedImage)
                        completion(imageResponse: .Success(image: croppedImage))
                    } else {
                        completion(imageResponse: .Error)
                    }
                } else {
                    self?.insert(key, image: image)
                    completion(imageResponse: .Success(image: image))
                }
            }
        }
        
        task.resume()
    }

    func image(forUrl url: NSURL, completion: (imageResponse: ImageResponse) -> ()) {
        image(forUrl: url, key: url.absoluteString, completion: completion)
    }

    func croppedImage(forUrl url: NSURL, cropRect: CGRect, completion: (imageResponse: ImageResponse) -> ()) {
        image(forUrl: url, key: url.absoluteString, cropRect: cropRect, completion: completion)
    }
}
