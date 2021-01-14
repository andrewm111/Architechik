//
//  CourseStructureModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct CourseStructure: Hashable, Codable {
    var id: Int64?
    var courseId: Int
    var title: String
    var description: String
    var category: String
    var file: String
}
