//
//  CourseCD+CoreDataProperties.swift
//  Architechik
//
//  Created by Александр Цветков on 28.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData

extension CourseCD {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CourseCD> {
        return NSFetchRequest<CourseCD>(entityName: "CourseCD")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var descriptionShort: String
    @NSManaged public var descriptionFull: String
    @NSManaged public var idCategory: String?
    @NSManaged public var category: String?
    @NSManaged public var price: String
    @NSManaged public var courseNumber: String
    @NSManaged public var image: String

}
