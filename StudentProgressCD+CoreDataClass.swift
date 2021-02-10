//
//  StudentProgressCD+CoreDataClass.swift
//  Architechik
//
//  Created by Александр Цветков on 08.02.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//
//

import Foundation
import CoreData


public class StudentProgressCD: NSManagedObject {

    func configure(withModel model: StudentProgress) {
        self.id = model.id
        self.idCourses = model.idCourses
        self.studentToken = model.studentToken
        self.currentProgress = model.currentProgress
        self.courseAccess = model.courseAccess
    }
    
}
