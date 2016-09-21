//
//  ApplicationViewModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class ApplicationViewModel {

    func updateMetadata() {
        if MetadataManager.shouldUpdateMetadata() && MetadataManager.initialMetadataLoaded {
            MetadataManager.fetchMetadata {
                print("Finished updating Metadata")
            }
        }
    }
}
