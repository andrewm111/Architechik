//
//  GrammarArticleModel.swift
//  Architechik
//
//  Created by Александр Цветков on 11.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation
import GRDB

struct Grammar {
    var id: Int64?
    var title: String
    var description: String
    var category: String
    var img: String
    var file: String
}

extension Grammar: Hashable, Codable, FetchableRecord, MutablePersistableRecord {
    
}
