//
//  ArticleModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation
import GRDB

struct Articles {
    var id: Int64?
    var title: String
    var description: String
    var category: String
    var img: String
    var file: String
}

extension Articles: Hashable, Codable, FetchableRecord, MutablePersistableRecord {
    
}
