//
//  StudentsProgressModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation
import GRDB

struct StudentsProgress {
    var id: Int64?
    var studentToken: Int
    var courseId: Int
    var currentProgress: Int
    var courseAccess: Int
}

extension StudentsProgress: Hashable, Codable, FetchableRecord, MutablePersistableRecord {
    
}
