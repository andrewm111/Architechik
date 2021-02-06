//
//  CourseStructureModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Lesson: Hashable, Codable, LessonCellDataSource, CoreDataConvertible {
    
    var id: String
    var title: String
    var idCourses: String
    var idType: String
    var description: String
    var file: String
    var category: String? {
        return idType
    }
    var img: String?
    var isDone: Bool?
    
    internal init(id: String, title: String, idCourses: String, idType: String, description: String, file: String, img: String? = nil, isDone: Bool? = nil) {
        self.id = id
        self.title = title
        self.idCourses = idCourses
        self.idType = idType
        self.description = description
        self.file = file
        self.img = img
        self.isDone = isDone
    }
    
    init(fromModel model: LessonCD) {
        self.id = model.id
        self.title = model.title ?? ""
        self.idCourses = model.idCourses ?? ""
        self.idType = model.idType ?? ""
        self.description = model.descriptionShort ?? ""
        self.file = model.file ?? ""
        self.img = model.image
        self.isDone = model.isDone
    }
}
