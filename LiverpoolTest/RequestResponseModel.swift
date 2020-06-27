//
//  RequestResponseModel.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//

import Foundation

public struct ResponseModel: Decodable {
    var status: StatusModel?
//    var pageType: [String: Any]?
    var plpResults: PlpResults?
}

public struct StatusModel: Decodable {
    var status: String?
    var statusCode: Int?
}

public struct PlpResults: Decodable {
    var records: [Records]?
}

public struct Records: Decodable {
    
    var productId: String?
    var skuRepositoryId: String?
    var productDisplayName: String?
    var productType: String?
    var productRatingCount: Int?
    var productAvgRating: Double?
    var listPrice: Double?
    var minimumListPrice: Double?
    var maximumListPrice: Double?
    var promoPrice: Double?
    var minimumPromoPrice: Double?
    var maximumPromoPrice: Double?
    var isHybrid: Bool?
    var isMarketPlace: Bool?
    var isImportationProduct: Bool?
    var smImage: String?
    var lgImage: String?
    var xlImage: String?
    var groupType: String?
    var variantsColor: [VariantsColor]?
}

public struct VariantsColor: Decodable {
    var colorName: String?
    var colorHex: String?
    var colorImageURL: String?
}
