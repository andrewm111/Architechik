//
//  CourseModel+CoreDataProperties.swift
//  Architechik
//
//  Created by Александр Цветков on 28.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData

extension CourseModel {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CourseModel> {
        return NSFetchRequest<CourseModel>(entityName: "Course")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var descriptionShort: String
    @NSManaged public var descriptionFull: String
    @NSManaged public var idCategory: String
    @NSManaged public var category: String?
    @NSManaged public var price: String
    @NSManaged public var courseNumber: String
    @NSManaged public var image: String

}
