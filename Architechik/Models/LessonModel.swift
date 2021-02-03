//
//  CourseStructureModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Lesson: Hashable, Codable, LessonCellDataSource {
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
}
