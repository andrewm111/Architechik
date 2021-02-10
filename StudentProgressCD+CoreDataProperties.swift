//
//  StudentProgressCD+CoreDataProperties.swift
//  Architechik
//
//  Created by Александр Цветков on 08.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData

extension StudentProgressCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentProgressCD> {
        return NSFetchRequest<StudentProgressCD>(entityName: "StudentProgressCD")
    }

    @NSManaged public var id: String
    @NSManaged public var studentToken: String
    @NSManaged public var idCourses: String
    @NSManaged public var currentProgress: String
    @NSManaged public var courseAccess: String

}
