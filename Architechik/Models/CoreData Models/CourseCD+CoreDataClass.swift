//
//  CourseCD+CoreDataClass.swift
//  Architechik
//
//  Created by Александр Цветков on 28.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CourseCD)
public class CourseCD: NSManagedObject {
    func configure(withModel model: Course) {
        self.id = model.id
        self.title = model.title
        self.descriptionShort = model.description
        self.descriptionFull = model.fullDescription
        self.idCategory = model.idCategory
        self.category = model.category
        self.price = model.price
        self.courseNumber = model.courseNumber
        self.image = model.img
    }
}
