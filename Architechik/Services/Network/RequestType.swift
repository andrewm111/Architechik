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
    case getCourseStructure
    case post(String)
    
    func getPath() -> String {
        switch self {
        case .getTable(let tableName):
            return "?table=\(tableName)"
        case .getCourseStructure:
            return "?table=course_structure"
        case .post(_):
            //return "?token=123&type=get&course_id=1&password=abc_132-A-b"
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
        case (.post(let a), .post(let b)):
            return a == b
        default:
            return false
        }
    }
}
