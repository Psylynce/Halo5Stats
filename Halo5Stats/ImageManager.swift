//
//  ImageManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol CacheableImageModel {
    var typeIdentifier: String { get }
    var cacheIdentifier: String { get }
    var imageURL: NSURL { get }
    var placeholderImage: UIImage? { get }
}

protocol ImageRequestFetchCoordinator {
    func fetchImage(presenter: ImagePresenter, model: CacheableImageModel)
}

protocol ImagePresenter {
    func initiateImageRequest(coordinator: ImageRequestFetchCoordinator)
    func displayImage(model: CacheableImageModel, image: UIImage)
}

class ImageManager {

    static let sharedManager = ImageManager()

    struct Behaviors {
        static let allowCaching = true
    }

    // MARK: - Properties

    let fetchQueue = OperationQueue()

    // MARK: - Internal

    func cachedImage(model: CacheableImageModel) -> UIImage? {
        guard Behaviors.allowCaching else { return nil }

        if let image = getCachedImage(model) {
            return image
        }

        return nil
    }

    func fetchImage(model: CacheableImageModel, cachedOnly: Bool = false, completion: ((model: CacheableImageModel, image: UIImage?) -> Void)?) {
        if let cachedImage = cachedImage(model) {
            if let completion = completion {
                completion(model: model, image: cachedImage)
            }

            return
        }

        let fetchOperation = NSBlockOperation { [weak self] () -> Void in
            let imageUrl = model.imageURL
            let task = NSURLSession.halo5ConfiguredSession().dataTaskWithURL(imageUrl, completionHandler: { (data, response, error) -> Void in
                if let _ = error {
                    if let completion = completion {
                        completion(model: model, image: model.placeholderImage)
                    }
                }

                if let data = data, image = UIImage(data: data) {
                    self?.cacheImage(model, image: image)

                    if let completion = completion {
                        completion(model: model, image: image)
                    }
                } else {
                    if let completion = completion {
                        completion(model: model, image: model.placeholderImage)
                    }
                }
            })

            task.resume()
        }

        fetchQueue.addOperation(fetchOperation)
    }

    // MARK: - Private

    private func getCachedImage(model: CacheableImageModel) -> UIImage? {
        let imageName = cacheFilename(model)

        if let cache = cacheDirectory() {
            let imageUrl = cache.URLByAppendingPathComponent(imageName)

            if let data = NSData.init(contentsOfURL: imageUrl) {
                if let cachedImage = UIImage(data: data) {
                    return cachedImage
                }
            }
        }

        return nil
    }

    private func cacheImage(model: CacheableImageModel, image: UIImage) {
        let imageName = cacheFilename(model)

        if let cache = cacheDirectory() {
            let imageUrl = cache.URLByAppendingPathComponent(imageName)

            UIImagePNGRepresentation(image)?.writeToURL(imageUrl, atomically: true)
        }
    }

    private func cacheFilename(model: CacheableImageModel) -> String {
        let imageName = "\(model.typeIdentifier)_\(model.cacheIdentifier)"

        return imageName
    }

    private func cacheDirectory() -> NSURL? {
        let cacheDirectory: NSSearchPathDirectory = .CachesDirectory
        
        if let searchUrl = NSFileManager.defaultManager().URLsForDirectory(cacheDirectory, inDomains: .UserDomainMask).last {
            return searchUrl
        }
        
        return nil
    }
}
