//
//  GrammarCD+CoreDataClass.swift
//  
//
//  Created by Александр Цветков on 03.02.2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(GrammarCD)
public class GrammarCD: NSManagedObject {
    func configure(withModel model: Grammar) {
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
