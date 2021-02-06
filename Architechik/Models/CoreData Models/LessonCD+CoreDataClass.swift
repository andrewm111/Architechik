//
//  LessonCD+CoreDataClass.swift
//  
//
//  Created by Александр Цветков on 03.02.2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(LessonCD)
public class LessonCD: NSManagedObject {
    func configure(withModel model: Lesson) {
        self.category = model.category
        self.descriptionShort = model.description
        self.file = model.file
        self.id = model.id
        self.idCourses = model.idCourses
        self.idType = model.idType
        self.image = model.img
        self.isDone = model.isDone ?? false
        self.title = model.title
    }
}
