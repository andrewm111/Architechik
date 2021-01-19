//
//  RequestType.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

enum RequestType {
    case getTable(String)
    case getCourseStructure(String)
    case post(String)
    
    func getPath() -> String {
        switch self {
        case .getTable(let tableName):
            return "?table=\(tableName)"
        case .getCourseStructure(let id):
            return "?table=course_structure&id=\(id)"
        case .post(_):
            return ""
        }
    }
    
    func getHTTPMethod() -> String {
        switch self {
        case .getTable:
            return "GET"
        case .getCourseStructure:
            return "GET"
        case .post:
            return "POST"
        }
    }
    
    static func ==(lhs: RequestType, rhs: RequestType) -> Bool {
        switch (lhs, rhs) {
        case (.getCourseStructure, .getCourseStructure):
            return true
        case (.getTable, .getTable):
            return true
        case (.post, .post):
            return true
        default:
            return false
        }
    }
}
