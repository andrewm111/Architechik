//
//  StringConversion.swift
//  Architechik
//
//  Created by Александр Цветков on 19.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import Foundation

extension String {
    mutating func makeFields(rows: Array<(String, String, Bool)>) {
        var strings: Array<String> = []
        for row in rows {
            if row.2 || row.1 == "null" {
                strings.append("\n    \"\(row.0)\": \(row.1)")
            } else {
                strings.append("\n    \"\(row.0)\": \"\(row.1)\"")
            }
        }
        let string = "{" + strings.joined(separator: ",") + "\n}"
        self.insert(contentsOf: string, at: self.startIndex)
    }
    
    mutating func makeNewFields(rows: Array<(String, String, Bool)>) {
        var strings: Array<String> = []
        for row in rows {
            if row.2 {
                strings.append("\n        \"\(row.0)\": \(row.1)")
            } else {
                strings.append("\n        \"\(row.0)\": \"\(row.1)\"")
            }
        }
        let string = "{\n    \"new_fields\": {" + strings.joined(separator: ",") + "\n    }\n}"
        self.insert(contentsOf: string, at: self.startIndex)
    }
}
