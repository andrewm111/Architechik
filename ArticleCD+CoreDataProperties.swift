//
//  ArticleCD+CoreDataProperties.swift
//  Architechik
//
//  Created by Александр Цветков on 03.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData


extension ArticleCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleCD> {
        return NSFetchRequest<ArticleCD>(entityName: "ArticleCD")
    }

    @NSManaged public var id: String
    @NSManaged public var file: String?
    @NSManaged public var category: String?
    @NSManaged public var descriptionShort: String?
    @NSManaged public var idCategory: String?
    @NSManaged public var image: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?

}
