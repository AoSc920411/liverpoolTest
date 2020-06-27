//
//  RecordEntity+CoreDataProperties.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//
//

import Foundation
import CoreData


extension RecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordEntity> {
        return NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
    }

    @NSManaged public var groupType: String?
    @NSManaged public var isHybrid: Bool
    @NSManaged public var isImportationProduct: Bool
    @NSManaged public var isMarketPlace: Bool
    @NSManaged public var lgImage: String?
    @NSManaged public var listPrice: Double
    @NSManaged public var maximumListPrice: Double
    @NSManaged public var maximumPromoPrice: Double
    @NSManaged public var minimumListPrice: Double
    @NSManaged public var minimumPromoPrice: Double
    @NSManaged public var productAvgRating: Double
    @NSManaged public var productDisplayName: String?
    @NSManaged public var productId: String?
    @NSManaged public var productRatingCount: Int16
    @NSManaged public var productType: String?
    @NSManaged public var promoPrice: Double
    @NSManaged public var skuRepositoryId: String?
    @NSManaged public var smImage: String?
    @NSManaged public var xlImage: String?

}
