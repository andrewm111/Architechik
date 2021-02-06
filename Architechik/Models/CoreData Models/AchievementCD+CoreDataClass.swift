//
//  AchievementCD+CoreDataClass.swift
//  
//
//  Created by Александр Цветков on 03.02.2021.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(AchievementCD)
public class AchievementCD: NSManagedObject {
    func configure(withModel model: Achievement) {
        self.id = model.id
        self.idCourses = model.idCourses
        self.descriptionShort = model.description
        self.imgBad = model.imgBad
        self.imgGood = model.imgGood
        self.title = model.title
    }
}
