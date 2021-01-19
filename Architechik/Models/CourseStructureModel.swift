//
//  CourseStructureModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct CourseStructure: Hashable, Codable {
    var id: String
    var idCourses: String
    var idType: String
    var description: String
    var file: String
}
