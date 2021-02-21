//
//  CourseModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Course: Hashable, Codable, CoreDataConvertible {

    var id: String
    var title: String
    var description: String
    var fullDescription: String
    var idCategory: String?
    var category: String?
    var price: String
    var courseNumber: String
    var img: String
    var idProduct: String = ""
    var courseStructure: Array<Lesson>? = []
    
    internal init(id: String, title: String, description: String, fullDescription: String, idCategory: String? = nil, category: String? = nil, price: String, courseNumber: String, img: String, idProduct: String = "", courseStructure: Array<Lesson>? = []) {
        self.id = id
        self.title = title
        self.description = description
        self.fullDescription = fullDescription
        self.idCategory = idCategory
        self.category = category
        self.price = price
        self.courseNumber = courseNumber
        self.img = img
        self.courseStructure = courseStructure
        self.idProduct = idProduct
    }
    
    init(fromModel model: CourseCD) {
        self.id = model.id
        self.title = model.title
        self.description = model.descriptionShort
        self.fullDescription = model.descriptionFull
        self.idCategory = model.idCategory
        self.category = model.category
        self.price = model.price
        self.courseNumber = model.courseNumber
        self.img = model.image
    }
}
