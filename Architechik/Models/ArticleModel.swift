//
//  ArticleModel.swift
//  Architechik
//
//  Created by Александр Цветков on 08.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

struct Article: Hashable, Codable {
    var id: String
    var title: String
    var description: String
    var idCategory: String
    var img: String
    var file: String
}
