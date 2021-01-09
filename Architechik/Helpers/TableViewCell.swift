//
//  TableViewCell.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

protocol Reusable {}

extension Reusable where Self: UITableViewCell {
    static var reuseId: String {
        return String(describing: Self.self)
    }
}

class TableViewCell: UITableViewCell {
    
    func configure() {
        selectionStyle = .none
        backgroundColor = .clear
    }

}

extension TableViewCell: Reusable {}

