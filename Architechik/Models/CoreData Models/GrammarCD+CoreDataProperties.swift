//
//  GrammarCD+CoreDataProperties.swift
//  
//
//  Created by Александр Цветков on 03.02.2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension GrammarCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GrammarCD> {
        return NSFetchRequest<GrammarCD>(entityName: "GrammarCD")
    }

    @NSManaged public var category: String?
    @NSManaged public var descriptionShort: String?
    @NSManaged public var file: String?
    @NSManaged public var id: String
    @NSManaged public var idCategory: String?
    @NSManaged public var image: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var title: String?

}
