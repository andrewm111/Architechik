//
//  ArticleCD+CoreDataClass.swift
//  Architechik
//
//  Created by Александр Цветков on 03.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ArticleCD)
public class ArticleCD: NSManagedObject {
    func configure(withModel model: Article) {
        self.category = model.category
        self.descriptionShort = model.description
        self.file = model.file
        self.id = model.id
        self.idCategory = model.idCategory
        self.image = model.img
        self.isDone = false
        self.title = model.title
    }
}
