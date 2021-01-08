//
//  CourseModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation
import GRDB

struct Courses {
    var id: Int64?
    var title: String
    var description: String
    var full_description: String
    var category: String
    var price: Int
    var course_number: Int
    var img: String
}

extension Courses: Hashable, Codable, FetchableRecord, MutablePersistableRecord {
    
}
