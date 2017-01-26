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
    var imageURL: URL { get }
    var largeImageURL: URL? { get }
    var placeholderImage: UIImage? { get }
}

protocol ImageRequestFetchCoordinator {
    func fetchImage(_ presenter: ImagePresenter, model: CacheableImageModel)
}

protocol ImagePresenter {
    func initiateImageRequest(_ coordinator: ImageRequestFetchCoordinator)
    func displayImage(_ model: CacheableImageModel, image: UIImage)
}

class ImageManager {

    static let sharedManager = ImageManager()

    struct Behaviors {
        static let allowCaching = true
    }

    enum Style {
        case small
        case large
    }

    // MARK: - Properties

    let fetchQueue = OperationQueue()
    var style: Style = .small

    // MARK: - Internal

    func cachedImage(_ model: CacheableImageModel) -> UIImage? {
        guard Behaviors.allowCaching else { return nil }

        if let image = getCachedImage(model) {
            return image
        }

        return nil
    }

    func fetchImage(_ model: CacheableImageModel, cachedOnly: Bool = false, completion: ((_ model: CacheableImageModel, _ image: UIImage?) -> Void)?) {
        if let cachedImage = cachedImage(model) {
            if let completion = completion {
                completion(model, cachedImage)
            }

            return
        }

        let fetchOperation = Foundation.BlockOperation { [weak self] () -> Void in
            let imageUrl = self?.style == .small ? model.imageURL : (model.largeImageURL ?? model.imageURL)
            let task = URLSession.halo5ConfiguredSession().dataTask(with: imageUrl, completionHandler: { (data, response, error) -> Void in
                if let _ = error {
                    if let completion = completion {
                        completion(model: model, image: model.placeholderImage)
                    }
                }

                if let data = data, let image = UIImage(data: data) {
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

    fileprivate func getCachedImage(_ model: CacheableImageModel) -> UIImage? {
        let imageName = cacheFilename(model)

        if let cache = cacheDirectory() {
            let imageUrl = cache.appendingPathComponent(imageName)

            if let data = try? Data.init(contentsOf: imageUrl) {
                if let cachedImage = UIImage(data: data) {
                    return cachedImage
                }
            }
        }

        return nil
    }

    fileprivate func cacheImage(_ model: CacheableImageModel, image: UIImage) {
        let imageName = cacheFilename(model)

        if let cache = cacheDirectory() {
            let imageUrl = cache.appendingPathComponent(imageName)

            try? UIImagePNGRepresentation(image)?.write(to: imageUrl, options: [.atomic])
        }
    }

    fileprivate func cacheFilename(_ model: CacheableImageModel) -> String {
        var imageName = "\(model.typeIdentifier)_\(model.cacheIdentifier)"
        if style == .large {
            imageName += "_large"
        }

        return imageName
    }

    fileprivate func cacheDirectory() -> URL? {
        let cacheDirectory: Foundation.FileManager.SearchPathDirectory = .cachesDirectory
        
        if let searchUrl = Foundation.FileManager.default.urls(for: cacheDirectory, in: .userDomainMask).last {
            return searchUrl
        }
        
        return nil
    }
}
