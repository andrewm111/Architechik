//
//  StudentsProgressModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct StudentProgress: Hashable, Codable, CoreDataConvertible {
    
    var id: String
    var studentToken: String
    var idCourses: String
    var currentProgress: String
    var courseAccess: String
    
    internal init(id: String, studentToken: String, idCourses: String, currentProgress: String, courseAccess: String) {
        self.id = id
        self.studentToken = studentToken
        self.idCourses = idCourses
        self.currentProgress = currentProgress
        self.courseAccess = courseAccess
    }
    
    init(fromModel model: StudentProgressCD) {
        self.id = model.id
        self.studentToken = model.studentToken
        self.idCourses = model.idCourses
        self.currentProgress = model.currentProgress
        self.courseAccess = model.courseAccess
    }
}
