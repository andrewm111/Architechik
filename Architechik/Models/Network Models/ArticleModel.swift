//
//  ArticleModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Article: Hashable, Codable, LessonCellDataSource, CoreDataConvertible {
    
    var id: String
    var title: String
    var description: String
    var idCategory: String?
    var category: String?
    var img: String
    var file: String
    var isDone: Bool? = false
    
    internal init(id: String, title: String, description: String, idCategory: String? = nil, category: String? = nil, img: String, file: String, isDone: Bool? = false) {
        self.id = id
        self.title = title
        self.description = description
        self.idCategory = idCategory
        self.category = category
        self.img = img
        self.file = file
        self.isDone = isDone
    }
    
    init(fromModel model: ArticleCD) {
        self.id = model.id
        self.title = model.title ?? ""
        self.description = model.descriptionShort ?? ""
        self.idCategory = model.idCategory
        self.category = model.category
        self.img = model.image ?? ""
        self.file = model.file ?? ""
        self.isDone = model.isDone
    }
}
