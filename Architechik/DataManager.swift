//
//  DataManager.swift
//  Architechik
//
//  Created by Александр Цветков on 07.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit
import GRDB

class DataManager {
    
    static let shared = DataManager()
    let path = Bundle.main.path(forResource: "data", ofType: "sqlite") ?? ""
    
    fileprivate init() {
//        do {
//            let dbQueue = try DatabaseQueue(path: path)
//            try dbQueue.read { db in
//                let article = try Articles.filter(Column("id") == "4").fetchOne(db)
//                print(article)
//            }
//        } catch {
//            print(error)
//        }
    }
    
}
