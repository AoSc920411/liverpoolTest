//
//  SearchString+CoreDataProperties.swift
//  LiverpoolTest
//
//  Created by Alan Omar Solano Campos on 27/06/20.
//  Copyright © 2020 Alan Omar Solano Campos. All rights reserved.
//
//

import Foundation
import CoreData


extension SearchString {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchString> {
        return NSFetchRequest<SearchString>(entityName: "SearchString")
    }

    @NSManaged public var text: String?

}
