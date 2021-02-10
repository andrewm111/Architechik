//
//  AchievementModel.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

struct Achievement: Hashable, Codable, CoreDataConvertible {
    
    var id: String
    var title: String
    var description: String
    var idCourses: String?
    var imgGood: String
    var imgBad: String
    var progress: CGFloat? = 0
    
    internal init(id: String, title: String, description: String, idCourses: String? = nil, imgGood: String, imgBad: String) {
        self.id = id
        self.title = title
        self.description = description
        self.idCourses = idCourses
        self.imgGood = imgGood
        self.imgBad = imgBad
    }
    
    init(fromModel model: AchievementCD) {
        self.id = model.id
        self.title = model.title ?? ""
        self.description = model.descriptionShort ?? ""
        self.idCourses = model.idCourses
        self.imgGood = model.imgGood ?? ""
        self.imgBad = model.imgBad ?? ""
    }
}
