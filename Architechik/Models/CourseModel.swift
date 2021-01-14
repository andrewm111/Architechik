//
//  CourseModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Course: Hashable, Codable {
    var id: Int
    var title: String
    var description: String
    var fullDescription: String
    var category: String
    var price: Int
    var courseNumber: String
    var img: String
}
