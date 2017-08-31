//
//  ImageCache.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation
import UIKit

enum ImageResponse {
    case success(image: UIImage)
    case error
}

class ImageCache {

    static let sharedInstance = ImageCache()
    let cache = NSCache<AnyObject, AnyObject>()

    fileprivate func insert(_ key: String, image: UIImage) {
        cache.setObject(image, forKey: key as AnyObject)
    }

    fileprivate func cachedImage(forKey key: String) -> UIImage? {
        if let image = cache.object(forKey: key as AnyObject) as? UIImage {
            return image
        }

        return nil
    }

    fileprivate func image(forUrl url: URL, key: String, cropRect: CGRect? = nil, completion: @escaping (_ imageResponse: ImageResponse) -> ()) {
        if let image = cachedImage(forKey: key) {
            completion(.success(image: image))
            return
        }

        let urlRequest = Endpoint.haloRequest(with: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            guard let data = data, error == nil else { return }

            if let response = response as? HTTPURLResponse, response.statusCode == 404 {
                completion(.error)
            }

            if let image = UIImage(data: data) {
                if let rect = cropRect {
                    if let croppedImage = image.cropped(rect) {
                        self?.insert(key, image: croppedImage)
                        completion(.success(image: croppedImage))
                    } else {
                        completion(.error)
                    }
                } else {
                    self?.insert(key, image: image)
                    completion(.success(image: image))
                }
            }
        }) 
        
        task.resume()
    }

    func image(forUrl url: URL, completion: @escaping (_ imageResponse: ImageResponse) -> ()) {
        image(forUrl: url, key: url.absoluteString, completion: completion)
    }

    func croppedImage(forUrl url: URL, cropRect: CGRect, completion: @escaping (_ imageResponse: ImageResponse) -> ()) {
        image(forUrl: url, key: url.absoluteString, cropRect: cropRect, completion: completion)
    }
}
