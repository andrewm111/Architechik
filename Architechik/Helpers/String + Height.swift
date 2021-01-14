//
//  String + Height.swift
//  Architechik
//
//  Created by Александр Цветков on 13.01.2021.
//  Copyright © 2021 Александр Цветков. All rights reserved.
//

import UIKit

extension String {
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let size = self.boundingRect(with: textSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(size.height)
    }
}
