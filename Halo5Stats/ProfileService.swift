//
//  ProfileService.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct ProfileService {

    static let spartanHeadRect = CGRect(x: 75, y: 15, width: 250, height: 250)

    static func emblemUrl(forGamertag gamertag: String) -> NSURL {
        let emblemSubs = [
            APIConstants.GamertagKey : gamertag,
            APIConstants.ProfileTypeKey : APIConstants.emblem
        ]
        let emblemEndpoint = Endpoint(service: APIConstants.ProfileService, path: APIConstants.Profile)
        let emblemUrl = emblemEndpoint.url(withSubstitutions: emblemSubs)

        return emblemUrl
    }

    enum SpartanImageCropStyle: String {
        case portrait = "portrait"
        case full = "full"
    }

    static func spartanImageUrl(forGamertag gamertag: String, size: String = "256", crop: SpartanImageCropStyle = .full) -> NSURL {
        let spartanImageSubs = [
            APIConstants.GamertagKey : gamertag,
            APIConstants.ProfileTypeKey : APIConstants.spartan
        ]
        let params = [
            APIConstants.ProfileSize : size,
            APIConstants.ProfileSpartanCrop : crop.rawValue
        ]
        let spartanImageEndpoint = Endpoint(service: APIConstants.ProfileService, path: APIConstants.Profile, parameters: params)
        let spartanImageUrl = spartanImageEndpoint.url(withSubstitutions: spartanImageSubs)

        return spartanImageUrl
    }
}

extension UIImageView {

    func spartanHeadImage(forGamertag gamertag: String) {
        let url = ProfileService.spartanImageUrl(forGamertag: gamertag, size: "512", crop: .portrait)
        croppedImage(forUrl: url, cropRect: ProfileService.spartanHeadRect)
    }
}
