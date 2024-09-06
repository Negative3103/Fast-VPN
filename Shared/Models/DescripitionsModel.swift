//
//  DescripitionsModel.swift
//  FastVPN
//
//  Created by Хасан Давронбеков on 13/08/24.
//

import Foundation

struct DescriptionsModel {
    let title: String
    
    static let descriptions: [DescriptionsModel] = [
        DescriptionsModel(title: "fasterThanLightning".localized),
        DescriptionsModel(title: "wontBlock".localized),
        DescriptionsModel(title: "doesntDischarge".localized),
        DescriptionsModel(title: "paymentRF".localized),
        DescriptionsModel(title: "heatPhone".localized),
        DescriptionsModel(title: "fastSupport".localized)
    ]
}
