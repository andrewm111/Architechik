//
//  AchievementCD+CoreDataProperties.swift
//  
//
//  Created by Александр Цветков on 03.02.2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension AchievementCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AchievementCD> {
        return NSFetchRequest<AchievementCD>(entityName: "AchievementCD")
    }

    @NSManaged public var descriptionShort: String?
    @NSManaged public var id: String
    @NSManaged public var idCourses: String?
    @NSManaged public var imgBad: String?
    @NSManaged public var imgGood: String?
    @NSManaged public var title: String?

}
