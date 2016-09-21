//
//  MedalImageManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol MedalImageRequestFetchCoordinator {
    func fetchMedalImage(presenter: MedalImagePresenter, medal: MedalModel)
}

protocol MedalImagePresenter {
    func initiateMedalImageRequest(coordinator: MedalImageRequestFetchCoordinator)
    func displayMedalImage(medal: MedalModel, image: UIImage)
}

class MedalImageManager {

    struct Behaviors {
        static let allowCaching = true
    }

    struct ImageNames {
        static let placeholder = "Medal"
    }

    // MARK: - Properties

    let placeholderImage = UIImage(named: ImageNames.placeholder)?.imageWithRenderingMode(.AlwaysTemplate)
    let fetchQueue = OperationQueue()

    // MARK: - Internal

    func cachedMedalImage(medal: MedalModel) -> UIImage? {
        guard Behaviors.allowCaching else { return nil }

        if let image = cachedImage(medal) {
            return image
        }

        return nil
    }

    func fetchMedalImage(medal: MedalModel, cachedOnly: Bool = false, completion: ((medal: MedalModel, image: UIImage?) -> Void)?) {
        if let cachedImage = cachedImage(medal) {
            if let completion = completion {
                completion(medal: medal, image: cachedImage)
            }

            return
        }

        let fetchOperation = NSBlockOperation { [weak self] () -> Void in
            let imageUrl = medal.imageUrl
            let task = NSURLSession.halo5ConfiguredSession().dataTaskWithURL(imageUrl) { (data, response, error) -> Void in
                if let _ = error {
                    if let completion = completion {
                        completion(medal: medal, image: self?.placeholderImage)
                    }
                }

                if let data = data, image = UIImage(data: data) {
                    let croppedMedal = CGRect(x: medal.xPosition, y: medal.yPosition, width: medal.width, height: medal.height)
                    if let croppedImage = image.cropped(croppedMedal) {
                        self?.cacheImage(medal, image: croppedImage)

                        if let completion = completion {
                            completion(medal: medal, image: croppedImage)
                        }
                    } else {
                        if let completion = completion {
                            completion(medal: medal, image: self?.placeholderImage)
                        }
                    }
                }
            }

            task.resume()
        }

        fetchQueue.addOperation(fetchOperation)
    }

    // MARK: - Private

    private func cachedImage(medal: MedalModel) -> UIImage? {
        let imageName = cacheFilename(medal)

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

    private func cacheImage(medal: MedalModel, image: UIImage) {
        let imageName = cacheFilename(medal)

        if let cache = cacheDirectory() {
            let imageUrl = cache.URLByAppendingPathComponent(imageName)

            UIImagePNGRepresentation(image)?.writeToURL(imageUrl, atomically: true)
        }
    }

    private func cacheFilename(medal: MedalModel) -> String {
        let imageName = "Medal_\(medal.cacheIdentifier)"

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
