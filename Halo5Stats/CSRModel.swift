//
//  CSRModel.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

struct CSRModel {

    var name: String
    var csr: Int
    var tier: Int
    var rank: Int?
    var designationId: Int
    var csrImageUrl: NSURL

    static func convert(csr: AttainedCSR) -> CSRModel? {
        guard let designationId = csr.designationId as? Int else { return nil }
        guard let designation = CSRDesignation.csrDesignation(designationId) else { return nil }
        guard let name = designation.name else { return nil }
        guard let newCsr = csr.csr as? Int else { return nil }
        guard let tierId = csr.tier as? Int else { return nil }
        guard let csrTier = designation.tier(tierId) else { return nil }
        guard let iconUrlString = csrTier.iconImageUrl, url = NSURL(string: iconUrlString) else { return nil }

        let rank = csr.rank as? Int

        let model = CSRModel(name: name, csr: newCsr, tier: tierId, rank: rank, designationId: designationId, csrImageUrl: url)
        
        return model
    }
}
