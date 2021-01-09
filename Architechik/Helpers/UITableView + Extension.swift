//
//  UITableView + Extension.swift
//  Architechik
//
//  Created by Александр Цветков on 09.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: TableViewCell>(_ :T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseId)
    }
    
    func dequeueReusableCell<T: TableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseId, for: indexPath) as? T else {
            return T()
        }
        return cell
    }
    
}
