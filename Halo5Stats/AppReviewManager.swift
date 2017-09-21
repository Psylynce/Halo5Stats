//
//  AppReviewManager.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import Foundation
import StoreKit

final class AppReviewManager {

    static let shared = AppReviewManager()

    enum Key: String {
        case matchViewed
        case compareViewed
    }

    func updateCount(for key: Key) {
        var count = checkCount(for: key)
        count += 1
        UserDefaults.standard.set(count, forKey: key.rawValue)

        var showReview = false
        switch key {
        case .matchViewed:
            showReview = count % 10 == 0
        case .compareViewed:
            showReview = count % 7 == 0
        }

        if showReview {
            SKStoreReviewController.requestReview()
        }
    }

    private func checkCount(for key: Key) -> Int {
        let count = UserDefaults.standard.integer(forKey: key.rawValue)

        if count > 100 {
            UserDefaults.standard.set(0, forKey: key.rawValue)
        }

        return count
    }
}
