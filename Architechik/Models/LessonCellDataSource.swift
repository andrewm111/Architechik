//
//  LessonCellDataSource.swift
//  Architechik
//
//  Created by Александр Цветков on 23.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

protocol LessonCellDataSource {
    var id: String { get set }
    var title: String { get set }
    var description: String { get set }
    var isDone: Bool? { get set }
    var category: String? { get }
}
