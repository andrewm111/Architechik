//
//  AchievementModel.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Achievement: Hashable, Codable {
    var id: String
    var title: String
    var description: String
    var idCourses: String?
    var imgGood: String
    var imgBad: String
}
