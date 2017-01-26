//
//  MedalImageManager.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

protocol MedalImageRequestFetchCoordinator {
    func fetchMedalImage(_ presenter: MedalImagePresenter, medal: MedalModel)
}

protocol MedalImagePresenter {
    func initiateMedalImageRequest(_ coordinator: MedalImageRequestFetchCoordinator)
    func displayMedalImage(_ medal: MedalModel, image: UIImage)
}

class MedalImageManager {

    struct Behaviors {
        static let allowCaching = true
    }

    struct ImageNames {
        static let placeholder = "Medal"
    }

    // MARK: - Properties

    let placeholderImage = UIImage(named: ImageNames.placeholder)?.withRenderingMode(.alwaysTemplate)
    let fetchQueue = OperationQueue()

    // MARK: - Internal

    func cachedMedalImage(_ medal: MedalModel) -> UIImage? {
        guard Behaviors.allowCaching else { return nil }

        if let image = cachedImage(medal) {
            return image
        }

        return nil
    }

    func fetchMedalImage(_ medal: MedalModel, cachedOnly: Bool = false, completion: ((_ medal: MedalModel, _ image: UIImage?) -> Void)?) {
        if let cachedImage = cachedImage(medal) {
            if let completion = completion {
                completion(medal, cachedImage)
            }

            return
        }

        let fetchOperation = Foundation.BlockOperation { [weak self] () -> Void in
            let imageUrl = medal.imageUrl
            let task = URLSession.halo5ConfiguredSession().dataTask(with: imageUrl, completionHandler: { (data, response, error) -> Void in
                if let _ = error {
                    if let completion = completion {
                        completion(medal: medal, image: self?.placeholderImage)
                    }
                }

                if let data = data, let image = UIImage(data: data) {
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
            }) 

            task.resume()
        }

        fetchQueue.addOperation(fetchOperation)
    }

    // MARK: - Private

    fileprivate func cachedImage(_ medal: MedalModel) -> UIImage? {
        let imageName = cacheFilename(medal)

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

    fileprivate func cacheImage(_ medal: MedalModel, image: UIImage) {
        let imageName = cacheFilename(medal)

        if let cache = cacheDirectory() {
            let imageUrl = cache.appendingPathComponent(imageName)

            try? UIImagePNGRepresentation(image)?.write(to: imageUrl, options: [.atomic])
        }
    }

    fileprivate func cacheFilename(_ medal: MedalModel) -> String {
        let imageName = "Medal_\(medal.cacheIdentifier)"

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
